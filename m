Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbZDHFut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbZDHFut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbZDHFuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:50:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755706AbZDHFuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:50:39 -0400
Date: Tue, 7 Apr 2009 22:47:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [0/16] POISON: Intro
Message-Id: <20090407224709.742376ff.akpm@linux-foundation.org>
In-Reply-To: <20090407509.382219156@firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Apr 2009 17:09:56 +0200 (CEST) Andi Kleen <andi@firstfloor.org> wrote:

> Upcoming Intel CPUs have support for recovering from some memory errors. This
> requires the OS to declare a page "poisoned", kill the processes associated
> with it and avoid using it in the future. This patchkit implements
> the necessary infrastructure in the VM.

Seems that this feature is crying out for a testing framework (perhaps
it already has one?).  A simplistic approach would be

	echo some-pfn > /proc/bad-pfn-goes-here

A slightly more sophisticated version might do the deed from within a
timer interrupt, just to get a bit more coverage.

