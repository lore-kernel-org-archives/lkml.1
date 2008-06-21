Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbYFUQlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbYFUQlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 12:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYFUQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 12:41:08 -0400
Received: from nn7.de ([85.214.94.156]:57589 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYFUQlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 12:41:07 -0400
Subject: Re: hdparm -M acoustic management for sata disks?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <485D098E.3080109@rtr.ca>
References: <1214043295.17302.16.camel@localhost>  <485D098E.3080109@rtr.ca>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Jun 2008 18:40:56 +0200
Message-Id: <1214066456.18959.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-21 at 10:00 -0400, Mark Lord wrote:
> Soeren Sonnenburg wrote:
> > Dear all,
> > 
> > why is acoustic management via hdparm not supported for sata disks?
> > 
> > # hdparm -M /dev/sda
> > 
> > /dev/sda:
> >  acoustic      = not supported
> ..
> 
> No, that means that your *drive* doesn't support it.
> Check for yourself, with "hdparm -I /dev/sda | grep Acoustic".

Just to be sure, did you mean grep acoustic (lowercase)? Because it is
listed there under Capabilities: 
Recommended acoustic management value: 128, current value: 0

I've tried with the 5 sata drives I could get my hands on, they all list
some recommended acoustic management value but all fail the same way

# hdparm -M 128 /dev/sda

/dev/sda:
 setting acoustic management to 128
 HDIO_DRIVE_CMD:ACOUSTIC failed: Input/output error
 acoustic      = not supported

> ..
> > Is there any patch flying around that already enables this or even any
> > ETA in the current mainstream?
> ..
> 
> No patch required -- hdparm (newer versions) already do this correctly.

I have hdparm v8.9 here, is that new enough?

Thanks for you help,
Soeren
