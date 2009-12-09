Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZLIP3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZLIP3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbZLIP3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:29:16 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41461 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753676AbZLIP3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:29:15 -0500
Date: Wed, 9 Dec 2009 10:29:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       "David S. Miller" <davem@davemloft.net>
cc: Greg KH <greg@kroah.com>, <linux-next@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: staging tree build failure
In-Reply-To: <20091209165646.41b9ce8a.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.44L0.0912091026210.4120-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Stephen Rothwell wrote:

> Hi Greg,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/net/usb/kaweth.c: In function 'kaweth_open':
> drivers/net/usb/kaweth.c:719: error: implicit declaration of function 'usb_autopm_enable'
> 
> Caused by commit b3f937e6ddf3e60ed9b4c26349b7b171dffdd010 ("USB: prepare
> for changover to Runtime PM framework").
> 
> I have reverted that commit for today.

This should have been okay because of Oliver's patch:

	http://marc.info/?l=linux-netdev&m=125071045301270&w=2

which removed the offending reference.  Hasn't it been merged yet?  
It was submitted back in August.

Alan Stern

