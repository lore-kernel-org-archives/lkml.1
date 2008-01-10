Return-Path: <linux-kernel-owner+w=401wt.eu-S1761961AbYAJPLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961AbYAJPLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbYAJPCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:02:13 -0500
Received: from twin.jikos.cz ([213.151.79.26]:53362 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759641AbYAJPCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:02:07 -0500
Date: Thu, 10 Jan 2008 16:01:44 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Matthew Wilcox <matthew@wil.cx>, Nikanth Karthikesan <knikanth@suse.de>,
       grant@torque.net, tim@cyberelk.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Change paride driver to use unlocked_ioctl instead of
 ioctl
In-Reply-To: <20080109165641.668838af@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0801101601000.25041@twin.jikos.cz>
References: <4785B7BC.5040106@suse.de> <4785C7D8.2020808@suse.de>
 <20080109123311.GP16309@parisc-linux.org> <Pine.LNX.4.64.0801091425100.25041@twin.jikos.cz>
 <20080109165641.668838af@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008, Alan Cox wrote:

> > > >  	default:
> > > >  		printk("%s: Unimplemented ioctl 0x%x\n", tape->name, cmd);
> > > > +		unlock_kernel();
> > > >  		return -EINVAL;
> > > Surely a bug ... shouldn't this return -ENOTTY?
> Agreed - ENOTTY. 

Just out of curiosity, where does POSIX happen to specify ENOTTY as the 
correct one for unimplemented ioctl?

-- 
Jiri Kosina
