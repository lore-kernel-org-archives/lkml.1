Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbZIGBsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbZIGBsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 21:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbZIGBsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 21:48:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:37879 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758313AbZIGBsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 21:48:12 -0400
Date: Mon, 7 Sep 2009 11:48:09 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: sds@tycho.nsa.gov, casey@schaufler-ca.com, gregkh@suse.de,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/3] sysfs: Add labeling support for sysfs
In-Reply-To: <1252002358-6612-4-git-send-email-dpquigl@tycho.nsa.gov>
Message-ID: <alpine.LRH.2.00.0909071147100.2538@tundra.namei.org>
References: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov> <1252002358-6612-4-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This last patch introduced the following warnings:

fs/sysfs/inode.c: In function sysfs_setxattr:
fs/sysfs/inode.c:150: warning: passing argument 2 of 
security_inode_getsecctx from incompatible pointer type
include/linux/security.h:1883: note: expected void ** but argument is of type char ** 
fs/sysfs/inode.c:129: warning: unused variable suffix


Please fix them.  Thanks.



- James
-- 
James Morris
<jmorris@namei.org>
