Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbZDHFTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbZDHFTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZDHFTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:19:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbZDHFTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:19:39 -0400
Date: Tue, 7 Apr 2009 22:15:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [0/16] POISON: Intro
Message-Id: <20090407221542.91cd3c42.akpm@linux-foundation.org>
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

If the page is clean then we can just toss it and grab a new one from
backing store without killing anyone.

Does the patchset do that?
