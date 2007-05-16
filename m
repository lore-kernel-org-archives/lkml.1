Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbXEPXEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbXEPXEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758501AbXEPXE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:04:26 -0400
Received: from twin.jikos.cz ([213.151.79.26]:41453 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025AbXEPXEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:04:25 -0400
Date: Thu, 17 May 2007 01:03:55 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, maxk@qualcomm.com,
       bluez-devel@lists.sourceforge.net, Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: 2.6.21-rc7: BUG: sleeping function called from invalid context
 at net/core/sock.c:1523
In-Reply-To: <Pine.LNX.4.64.0705161418250.25986@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0705170102290.13706@twin.jikos.cz>
References: <462D1B09.9050005@goop.org>  <Pine.LNX.4.64.0704232257090.20657@twin.jikos.cz>
  <Pine.LNX.4.64.0704261625410.20657@twin.jikos.cz> 
 <a781481a0705110629n7c7130c1x3a89fa958b271f20@mail.gmail.com> 
 <Pine.LNX.4.64.0705161124030.25986@twin.jikos.cz> 
 <a781481a0705160436s3564022aybd9b318ec0947d94@mail.gmail.com> 
 <1179315904.10069.67.camel@violet>  <a781481a0705160456q778cfb4dk67d754317d57e9bb@mail.gmail.com>
  <a781481a0705160459p2d538d7fu8096bd594d6df2f9@mail.gmail.com>
 <1179317775.10069.77.camel@violet> <Pine.LNX.4.64.0705161418250.25986@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Jiri Kosina wrote:

> > since Jiri has a good test case for it, I leave it to him for testing.
> > If he confirms that this fixes the locking issues, then this is
> > Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> I will verify later this evening and will let you know. I am however 
> pretty convinced now that this is the right fix.

Satyam,

I have just verified that this locking scheme is indeed correct. So you 
can add

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

if you wish to, and submit the patch to Andrew.

Thanks,

-- 
Jiri Kosina
