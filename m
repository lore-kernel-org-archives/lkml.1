Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYKSOHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYKSOHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYKSOHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:07:42 -0500
Received: from styx.suse.cz ([82.119.242.94]:43537 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753191AbYKSOHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:07:42 -0500
Date: Wed, 19 Nov 2008 15:07:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rafi Rubin <rafi@seas.upenn.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n-trig digitizer quirks
In-Reply-To: <49241D02.6020602@seas.upenn.edu>
Message-ID: <alpine.LNX.1.10.0811191505340.19853@jikos.suse.cz>
References: <Pine.LNX.4.61.0811141207210.12963@minus.seas.upenn.edu> <alpine.LNX.1.10.0811181525490.19853@jikos.suse.cz> <49232910.2030309@seas.upenn.edu> <alpine.LNX.1.10.0811191355280.19853@jikos.suse.cz> <492417D4.4090103@seas.upenn.edu>
 <alpine.LNX.1.10.0811191451000.19853@jikos.suse.cz> <49241D02.6020602@seas.upenn.edu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008, Rafi Rubin wrote:

> >> Also, if you do prefer using driver data like that, is the probe 
> >> function necessary to make it work?
> > Probe function is necesary, you need to parse the report descriptor 
> > (hid_parse()), activate the hardware (hid_hw_start()), etc.
> Just to confirm then, its not necessary if I'm not checking the driver 
> data for the quirk?

Correct; if you don't need to do anything special in the _probe function, 
the HID core will do everything necessary (descriptor parsing, 
low-level hardware initialization) for you.

-- 
Jiri Kosina
SUSE Labs
