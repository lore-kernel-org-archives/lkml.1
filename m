Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYANNBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYANNBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750695AbYANNBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:01:43 -0500
Received: from mail.hevs.ch ([153.109.23.15]:47909 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYANNBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:01:43 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: [RFC, PATCH, take 2] watchdog on generic gpio
Date: Mon, 14 Jan 2008 14:01:33 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200801141103.23744.marc.pignat@hevs.ch> <200801141206.39858.florian.fainelli@telecomint.eu>
In-Reply-To: <200801141206.39858.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801141401.33783.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian!

On Monday 14 January 2008, Florian Fainelli wrote:
...
> I would like this function to be supplied by the platform_data structure 
> because as I mentioned before, not all GPIO connected watchdog will simply 
> need a single bit to be toggled, but also sometimes a full GPIO line.
I understand your wish, but...
You told me that your plaform doesn't implement the generic gpio interface
(yet?), so this driver can't work for you.

...
> 
> If we do not supply any specific callback to keepalive the watchdog let's just 
> assume we need a single bit to be toggled if this is ok with you ?
This is not the only function to be changed, start, stop and keepalive (and
probably suspend/resume) should be changed, and when the 'Uniform Watchdog
Device Driver' will be merged, writing your driver dealing with more gpio will
be almost trivial.

Please make sure to look a the right place, the git tree for the unified
driver you have given is 17 month old... here is the latest:
http://git.kernel.org/?p=linux/kernel/git/wim/linux-2.6-watchdog-mm.git;a=summary

I'm trying to get this work merged because I use it, it works for me and I'm
almost sure I haven't got the only embedded system using a max823 connected
to a gpio.

Let me know if you want some help implementing your driver!

Regards

Marc
