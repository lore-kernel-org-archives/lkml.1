Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYJPUfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYJPUfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 16:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbYJPUfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 16:35:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259AbYJPUfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 16:35:37 -0400
Date: Thu, 16 Oct 2008 13:35:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SYSFS: Fix return values for sysdev_store_{ulong,int}
Message-Id: <20081016133530.1024528d.akpm@linux-foundation.org>
In-Reply-To: <20081013100303.GA32199@basil.nowhere.org>
References: <20081013100303.GA32199@basil.nowhere.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 12:03:03 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> SYSFS: Fix return values for sysdev_store_{ulong,int}
> 
> Always return the full size instead of the consumed
> length of the string in sysdev_store_{ulong,int}
> 
> This avoids EINVAL errors in some echo versions.

That sounds fairly serious.  Is this a regression or are those versions
of echo really ancient, or...?
