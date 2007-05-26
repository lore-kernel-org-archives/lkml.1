Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbXEZSpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbXEZSpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 14:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbXEZSpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 14:45:35 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:35845 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbXEZSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 14:45:34 -0400
Date: Sat, 26 May 2007 14:45:32 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: casey@schaufler-ca.com, Andreas Gruenbacher <agruen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
In-Reply-To: <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
Message-ID: <Line.LNX.4.64.0705261442000.23020@d.namei>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com>
 <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007, Kyle Moffett wrote:

> AppArmor).  On the other hand, if you actually want to protect the _data_,
> then tagging the _name_ is flawed; tag the *DATA* instead.

Bingo.  

(This is how traditional Unix DAC has always functioned, and is what 
SELinux does: object labeling).


- James
-- 
James Morris
<jmorris@namei.org>
