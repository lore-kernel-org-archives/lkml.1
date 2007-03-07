Return-Path: <linux-kernel-owner+w=401wt.eu-S1161027AbXCGAhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027AbXCGAhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161028AbXCGAhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:37:12 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42289 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161027AbXCGAhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:37:10 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Mar 2007 16:37:09 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Avi Kivity <avi@argo.co.il>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <45ED1A3C.6030707@argo.co.il>
Message-ID: <Pine.LNX.4.64.0703061635430.3661@alien.or.mcafeemobile.com>
References: <45ED1A3C.6030707@argo.co.il>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Avi Kivity wrote:

> Right.  For kvmfs this isn't a problem as there's a 1:1 relationship 
> between synthetic inodes and dentries.  Perhaps d_alloc_anon() could be 
> extended to avoid the scan if it's a problem.

I currently have the dentry to carry the name of the file* class it is 
linked to. I'd prefer to keep it that way, unless there are huge factors 
against.



- Davide


