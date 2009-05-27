Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbZE0Ng0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbZE0Ng0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762139AbZE0NgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:36:18 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:45924 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760731AbZE0NgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:36:18 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: i2c-viapro / via-fb drivers on VIA CX700
Date: Wed, 27 May 2009 08:36:12 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905241332.39946.lkml@morethan.org> <20090525013132.GA8702@prithivi.gnumonks.org>
In-Reply-To: <20090525013132.GA8702@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905270836.17802.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun May 24 2009, Harald Welte wrote:
> On Sun, May 24, 2009 at 01:32:37PM -0500, Michael S. Zick wrote:
> 
> > The i2c-viapro driver (in spite of its comments) does not work
> > on CX700 (written before manual was released) - it is reading
> > the serial number rather than the second data port. ;)
> > (No access to the chipset temperature/voltage data on SMBus).
> 
> This is surprising.  I just manually verified the driver against the
> cx700 programming manual, and it seems to do the right thing.  Lacking
> access to a cx700 board right now, I cannot perform an actual test.
> 
> Where exactly is the bug about the wrong register that you mentioned?
> I'd rather fix that ASAP.
> 

I'll send you some reference material on how Everex is using the SMBus
on their ce1200v (the original Cloudbook) off-list.

Mike
