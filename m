Return-Path: <linux-kernel-owner+w=401wt.eu-S1764409AbXE2T6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764409AbXE2T6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757949AbXE2T6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:58:25 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:47767 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbXE2T6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:58:24 -0400
Date: Tue, 29 May 2007 15:58:21 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSMhook
In-Reply-To: <671296.4187.qm@web36604.mail.mud.yahoo.com>
Message-ID: <Line.LNX.4.64.0705291555020.9955@d.namei>
References: <671296.4187.qm@web36604.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Casey Schaufler wrote:

> > Conventional UNIX's access control can't restrict
> > which path_to_file can link with which another_path_to_file
> > because UNIX's access control is a label-based access control.
> 
> UNIX access control is attribute based, not label based. The
> distinction may be hair splitting in the current context, but
> could be significant later if the thread continues. 

What's important is that traditional DAC stores the security attributes 
of the object with the object.  Call them what you want, it matters not.


- James
-- 
James Morris
<jmorris@namei.org>
