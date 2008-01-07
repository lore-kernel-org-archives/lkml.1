Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYAGJXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYAGJXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 04:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYAGJXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 04:23:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:32934 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbYAGJXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 04:23:06 -0500
Date: Mon, 7 Jan 2008 09:22:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Gabor Gombas <gombasg@sztaki.hu>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080107092256.GX27894@ZenIV.linux.org.uk>
References: <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <477F9481.2040505@gmail.com> <20080105194510.GK27894@ZenIV.linux.org.uk> <478037F8.8020103@gmail.com> <47819079.3000606@gmail.com> <m1abnikpuz.fsf@ebiederm.dsl.xmission.com> <4781EE20.6070701@gmail.com> <4781EE5D.1000105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4781EE5D.1000105@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 06:18:21PM +0900, Tejun Heo wrote:
> Tejun Heo wrote:
> > Eric W. Biederman wrote:
> >>> That said, the mechanism is a bit too fragile.  sysfs currently ensures
> >>> that dentry/inode point to the associated sysfs_dirent.  This is mainly
> >>> remanent of conversion from previous VFS based implementation.  I think
> >>> the right thing to do here is to make sysfs behave like other proper
> >>> distributed filesystems using d_revalidate.
> >> Huh?  We still need something like sysfs_get_dentry to find the dentries
> >> for the rename or move operation.  So we can call d_move.  
> > 
> > Ah... right.  Thanks.  :-)
> 
> On the second thought, can't those too be dealt with d_revalidate?

FVO "dealt with" as pleasant and efficient as using coarse whetstone
to deal with caries.
