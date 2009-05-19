Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZESLya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZESLya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZESLyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:54:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbZESLyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:54:23 -0400
Date: Tue, 19 May 2009 07:54:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Bob Copeland <me@bobcopeland.com>
cc: Nick Kossifidis <mickflemm@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       jirislaby@gmail.com, lrodriguez@atheros.com,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ath5k: prevent infinite loop
In-Reply-To: <20090519114240.GA13934@hash.localnet>
Message-ID: <alpine.DEB.2.00.0905190751200.1767@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905182011270.7956@gandalf.stny.rr.com> <40f31dec0905181734t6a3db7f4peb2d57c3aebe075b@mail.gmail.com> <alpine.DEB.2.00.0905182041470.7956@gandalf.stny.rr.com> <40f31dec0905182332v49aff368oe485efaa56fbc11a@mail.gmail.com>
 <20090519114240.GA13934@hash.localnet>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 May 2009, Bob Copeland wrote:

> On Tue, May 19, 2009 at 09:32:42AM +0300, Nick Kossifidis wrote:
> > >> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/phy.c;h=d0d1c350025aebba1fe4e17a44550536a59951ba;hb=HEAD
> 
> > -> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/eeprom.c;h=c56b494d417acd40d445d922f2861b53cc2315df;hb=HEAD#l910
> 
> Do these patches need to go to 2.6.30?
> 

Considering that it locked up my box, I would think that it should. Well, 
at least the change that checks for the infinite loop.

-- Steve

