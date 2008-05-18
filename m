Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYERXTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYERXTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 19:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYERXT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 19:19:27 -0400
Received: from namei.org ([69.55.235.186]:51192 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753148AbYERXT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 19:19:26 -0400
Date: Mon, 19 May 2008 09:18:25 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Richard Kennedy <richard@rsk.demon.co.uk>
cc: sds@tycho.nsa.gov, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selinux: reorder inode_security_struct to increase
 objs/slab on 64bit
In-Reply-To: <1211110377.3021.8.camel@castor.localdomain>
Message-ID: <Xine.LNX.4.64.0805190916290.12130@us.intercode.com.au>
References: <1211110377.3021.8.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008, Richard Kennedy wrote:

> reorder inode_security_struct to remove padding on 64 bit builds
>     
> size reduced from 72 to 64 bytes increasing objects per slab to 64.
>         
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Thanks, applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm

(Although I see a reduction from 164 to 160 bytes).


- James
-- 
James Morris
<jmorris@namei.org>
