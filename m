Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYCLW4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYCLW4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYCLW4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:56:34 -0400
Received: from phunq.net ([64.81.85.152]:46382 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752572AbYCLW4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:56:33 -0400
From: Daniel Phillips <phillips@phunq.net>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Wed, 12 Mar 2008 14:56:15 -0800
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803121029.54108.phillips@phunq.net> <47D81CD9.6000802@nortel.com>
In-Reply-To: <47D81CD9.6000802@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121556.15547.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 11:11, Chris Friesen wrote:
> Daniel Phillips wrote:
> > You seem to be calling Linux unreliable.
> 
> It's more reliable than many others, but it's not perfect.
> 
> Besides, there are many failure modes beyond the control of the kernel. 
>   Hardware errors can lock up the bus and prevent I/O, RAM modules can 
> go bad, technicians can yank out cards without waiting for the ready 
> light.

...disks can break, batteries on raid controllers can fail, etc, etc...

So you design for the number of nines you need, taking all factors
into account, and you design for the performance you need.  These are
cut and dried calculations.  FUD has no place here.

> For certain classes of devices it's necessary to plan for these sorts of 
> things, and a model where the on-disk structures may be inconsistent by 
> design is not going to be very attractive.

You are preaching to the converted.  Systems consisting of:

  linux + disks + batteries + ram + network + redundancy

can be as reliable as you need.  Respectfully, I would like to return
to the software engineering problem.  This driver solves a problem for
certain people.  Not niche people to be forgotten about.  If it does
not solve your problem then please just write a driver that does,
meanwhile this one needs some finishing work.  Lets get the proverbial
thousand eyeballs working.  Has anybody besides me compiled this yet?

Daniel
