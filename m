Return-Path: <linux-kernel-owner+w=401wt.eu-S965594AbXHaPiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965594AbXHaPiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbXHaPiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:38:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54174 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790AbXHaPiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:38:17 -0400
Date: Fri, 31 Aug 2007 16:38:15 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Forced unmounting for removable devices
Message-ID: <20070831153815.GM21089@ftp.linux.org.uk>
References: <46D622A5.2000205@aladin.ro> <46D83528.8090204@aladin.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D83528.8090204@aladin.ro>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 06:35:04PM +0300, Eduard-Gabriel Munteanu wrote:
> *This message was transferred with a trial version of CommuniGate(r) Pro*
> Salah Coronya wrote:
> >There are patches in -mm for revokeat()/frevoke(), which can be used to
> >implement exactly that. If a device "vanishes" (CD is removed in the
> >middle of loading, USB pend rive yanked out the middle of I/O, NFS
> >server thats gone MIA), A user-space program (maybe HAL) could iterate
> >over the open files and revoke() them, at which point the system can be
> >cleanly unmounted.

Bull.  It will not help you at all if a syscall is stuck.

> Sounds promising. Is there any glibc version that implements these 
> syscalls (googling for 'glibc' and 'frevoke' didn't help)? I'd like to 
> implement and test this on my Linux box with HAL.

Implementation that is there in -mm is broken; see discussion on the list.
