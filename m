Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbZFJLYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbZFJLYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZFJLYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:24:01 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:60431 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbZFJLYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:24:00 -0400
Date: Wed, 10 Jun 2009 07:23:57 -0400
From: William Thompson <wt@electro-mechanical.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, ath5k-devel <ath5k-devel@venema.h4ckr.net>
Subject: Re: 3com 3crxjk10075 with ath5k driver
Message-ID: <20090610112357.GB19203@electro-mechanical.com>
References: <20090609195100.GY19203@electro-mechanical.com> <b6c5339f0906091339j3784c36bxe888af16272fbcde@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c5339f0906091339j3784c36bxe888af16272fbcde@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 04:39:12PM -0400, Bob Copeland wrote:
> [CCed ath5k-devel]
> 
> On Tue, Jun 9, 2009 at 3:51 PM, William
> Thompson<wt@electro-mechanical.com> wrote:
> > This card has the "xjack" antennae which is supposed to disable the radio (I
> > thought it was in hardware, but it's not) when it is not extended. ?The
> > madwifi driver (Last time I actually used this card with it) did disable the
> > radio (Or refused packets, not sure which).
> 
> Huh, I wonder how that works.  Is disabling the radio an advertised feature?
> i.e. as opposed to just not working because the antenna is in?

I'm not sure if it was advertised that way, but according to 3com's site:
3Com-patented XJACK antenna design extends for use and retracts for safe
transport and to conserve power; no need to remove the PC Card from the
notebook while traveling

Sounds like it was intended that way.

> > The kernel ath5k driver (last tested 2.6.29.4) will work regardless if the
> > antannae is in or out.
> 
> I suppose it could be asserting something on rfkill gpios; ath5k hasn't had
> real rfkill support yet.  Anyone else know about these devices?

It's possible.  The LED on it goes off when it's pushed in.  Which reminds
me, I don't think the ath5k driver allows the LED to blink when it's
transmitting/receiving, it just stays on.
