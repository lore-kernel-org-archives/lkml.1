Return-Path: <linux-kernel-owner+w=401wt.eu-S1762935AbYBWUbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762935AbYBWUbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761348AbYBWUbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:31:11 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759854AbYBWUbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:31:09 -0500
Date: Sat, 23 Feb 2008 12:31:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
In-Reply-To: <47C08134.2030205@garzik.org>
Message-ID: <alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org>
References: <1203779614.3139.4.camel@localhost.localdomain> <47C08134.2030205@garzik.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Feb 2008, Jeff Garzik wrote:
> 
> I know I am probably shooting myself in the foot here, since I am the original
> author of mvsas, but...
> 
> Should we be adding new drivers during -rc?

I'm personally of the opinion that a new driver that doesn't add anything 
but itself (ie no infrastructure changes etc) is fine. I'd rather have a 
new, rough driver that might work, than no driver at all, and it's not 
like it can cause a regression if you don't enable it.

		Linus
