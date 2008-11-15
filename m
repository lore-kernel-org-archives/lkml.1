Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYKOEsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYKOEsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 23:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYKOEsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 23:48:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbYKOEsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 23:48:33 -0500
Date: Fri, 14 Nov 2008 20:48:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, harvey.harrison@gmail.com,
       sfrench@us.ibm.com
Subject: Re: mmotm 2008-11-14-17-14 uploaded
Message-Id: <20081114204816.a2c626cf.akpm@linux-foundation.org>
In-Reply-To: <20081115132811.f04ef8e1.kamezawa.hiroyu@jp.fujitsu.com>
References: <200811150115.mAF1FDpD010853@imap1.linux-foundation.org>
	<20081115132811.f04ef8e1.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2008 13:28:11 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 14 Nov 2008 17:15:12 -0800
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-11-14-17-14 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.28-rc4:
> > 
> 
> shows
>   MODPOST 771 modules
> ERROR: "global_cifs_sock_list" [fs/cifs/cifs.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> Maybe this ?
> patches/cifs-remove-global_extern-macro.patch
> 

Could be.  That GLOBAL_EXTERN thing should be held on the ground whilst
farm animals poop on its head, but my attempts to remove it have thus
far fallen on deaf inboxes.

I'll give up.
