Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZGGJPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZGGJPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZGGJPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:15:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZGGJPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:15:13 -0400
Date: Tue, 7 Jul 2009 11:15:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Andi Kleen <andi@firstfloor.org>
Cc: rjw@sisk.pl, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [regression] 2.6.30 leaking keys on console switch
In-Reply-To: <20090707091209.GB10187@basil.fritz.box>
Message-ID: <alpine.LNX.2.00.0907071114470.4994@wotan.suse.de>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090707091209.GB10187@basil.fritz.box>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Andi Kleen wrote:

> > Are you seeing with a specific keyboard type(s), or is this a general 
> > problem? 
> > Could you confirm whether it is specific either 
> > to PS2 or USB keyboards only, or it does happen for both?
> I'm only seeing it with a USB keyboard, haven't seen it with PS/2
> (but I rarely do console switches with PS/2, so might have missed it)
> The USB keyboard is a rather ordinary logitech keyboard.

Could you please gather 'evtest' output from the /dev/input/eventX device 
corresponding to your keyboard from the situation this problem triggers?

-- 
Jiri Kosina
SUSE Labs
