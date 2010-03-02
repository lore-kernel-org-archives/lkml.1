Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0CBI2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:28:25 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63552 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab0CBI2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:28:21 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Date: Tue, 02 Mar 2010 01:28:15 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH 0/2] Correct behavior for listxattr and 'trusted'
 xattrs
In-reply-to: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org>
To: James Morris <jmorris@namei.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       Alex Elder <aelder@sgi.com>, Chris Mason <chris.mason@oracle.com>,
       a.gruenbacher@computer.org
Message-id: <2B059650-E1D4-4BED-84A6-64C3419E0ACF@sun.com>
X-Mailer: Apple Mail (2.936)
References: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-03-02, at 01:01, James Morris wrote:
> I noticed that there are differences in the behavior of listxattr(2)  
> for
> xattrs in the trusted namespace.
>
> Some filesystems, such as ext[234], require CAP_SYS_ADMIN for this,  
> i.e.
> trusted xattr names are hidden from unprivileged users.

This matches my understanding of the trusted.* namespace.  It is  
settable by the kernel and root (CAP_SYS_ADMIN) but not regular users.

> I'm not sure what the initial intention was for the behavior, although
> given that several major filesystems are have been fielded with the
> CAP_SYS_ADMIN check, it seems most prudent to make this the standard
> behavior for all filesystems, in case any users are depending on it.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

