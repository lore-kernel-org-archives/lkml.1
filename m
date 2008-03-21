Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbYCUVKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbYCUVKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbYCUVJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:09:54 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53389 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756233AbYCUVJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:09:53 -0400
Subject: Re: [SCSI] fix media change events for polled devices
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
In-Reply-To: <47E422F1.7080806@garzik.org>
References: <200803211559.m2LFxPi6017869@hera.kernel.org>
	 <47E3EC67.4050404@garzik.org>
	 <1206128662.2961.37.camel@localhost.localdomain>
	 <47E41C50.4020406@garzik.org>
	 <1206133280.2961.45.camel@localhost.localdomain>
	 <47E422F1.7080806@garzik.org>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 16:09:47 -0500
Message-Id: <1206133787.2961.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-21 at 17:04 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > It's fixed, and nothing else is additionally broken by the current fix.
> 
> Other than the newly-inconsistent, exported-to-userspace interface, ITYM.

How is it newly inconsistent?  It can still be used in the manner you
intended it, namely to tell if the CD supports AN or not.  When we add
the new bit, we'll have to add a new file for it anyway.

James


