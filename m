Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbXEXB3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbXEXB3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbXEXB25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:28:57 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:37624 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545AbXEXB24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:28:56 -0400
Date: Wed, 23 May 2007 21:28:52 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Andreas Gruenbacher <agruen@suse.de>
cc: Al Viro <viro@ftp.linux.org.uk>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
In-Reply-To: <200705232106.28260.agruen@suse.de>
Message-ID: <Line.LNX.4.64.0705232109030.3178@d.namei>
References: <20070412090809.917795000@suse.de> <20070412090836.207973000@suse.de>
 <20070412101236.GD4095@ftp.linux.org.uk> <200705232106.28260.agruen@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Andreas Gruenbacher wrote:

> This is backwards from what AppArmor does. The policy defines which paths may 
> be accessed; all paths not explicitly listed are denied. If files are mounted 
> at multiple locations, then the policy may allow access to some locations but 
> not to others. That's not a hole.

I don't know what else you'd call it.

Would you mind providing some concrete examples of how such a model would 
be useful?


- James
-- 
James Morris
<jmorris@namei.org>
