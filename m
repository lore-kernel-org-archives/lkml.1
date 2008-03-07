Return-Path: <linux-kernel-owner+w=401wt.eu-S1762969AbYCGUJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762969AbYCGUJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYCGUJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:09:27 -0500
Received: from kai.krose.org ([140.186.190.96]:37659 "EHLO mail.krose.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbYCGUJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:09:26 -0500
Message-ID: <47D1A0F5.2070501@krose.org>
Date: Fri, 07 Mar 2008 15:09:25 -0500
From: Kyle Rose <krose@krose.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
Subject: Re: READDIRPLUS max mount option
References: <47D1995E.6060501@krose.org> <1204919978.16746.12.camel@heimdal.trondhjem.org>
In-Reply-To: <1204919978.16746.12.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The binary mount format is frozen forever, so the changes to nfs_mount.h
> and nfs4_mount.h are definitely NACKed.
>   
Ah. :-)  So is there no way to add mount options, or is there a 
different mechanism today?
> Otherwise, it would be nice to know why this absolutely has to be made a
> mount option rather than just having a system-wide option (either a
> module/boot parameter or a sysctl) to control the behaviour of all
> mounts.
>   
I mount multiple remote file systems.  Only one of them I own, so I'm 
willing to potentially hammer it with huge READDIRPLUS requests, while 
the others probably deserve more benign behavior. ;-)

In general, I think having system-wide defaults somewhere in proc is 
helpful---and certainly superior to a constant in the source---but there 
should really be mount-specific overrides wherever the system-wide 
default might not be globally appropriate.

Kyle

