Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbXDMHLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbXDMHLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 03:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXDMHLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 03:11:51 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:40704 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXDMHLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 03:11:50 -0400
To: herbert@13thfloor.at
CC: serue@us.ibm.com, miklos@szeredi.hu, containers@lists.osdl.org,
       viro@ftp.linux.org.uk, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-kernel@vger.kernel.org
In-reply-to: <20070413041612.GC25877@MAIL.13thfloor.at> (message from Herbert
	Poetzl on Fri, 13 Apr 2007 06:16:12 +0200)
Subject: Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
References: <20070412164541.580374744@szeredi.hu> <20070412164620.588752236@szeredi.hu> <20070412203208.GG27772@sergelap.austin.ibm.com> <20070413041612.GC25877@MAIL.13thfloor.at>
Message-Id: <E1HcFus-0001ZT-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 13 Apr 2007 09:09:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> question: how is mounting filesystems (loopback,
> fuse, etc) secured in such way that the user
> cannot 'create' device nodes with 'unfortunate'
> permissions?

All unprivileged mounts have "nosuid,nodev" added to their options.

Miklos
