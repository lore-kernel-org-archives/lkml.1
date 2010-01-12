Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638Ab0ALQgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0ALQgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560Ab0ALQgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:36:12 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:41245 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0ALQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:36:11 -0500
Message-ID: <4B4CA4E5.7030800@gmail.com>
Date: Tue, 12 Jan 2010 17:35:49 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: James Kosin <JKosin@intcomgrp.com>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: arm: Optimization for ethernet MAC handling at91_ether.c
References: <3DBBD805E3BA064A87F551C0E8BD3674028973F5@MAILSRV.intcomgrp.com>
In-Reply-To: <3DBBD805E3BA064A87F551C0E8BD3674028973F5@MAILSRV.intcomgrp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 12 Jan 2010 17:35:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC to netdev

Le 12/01/2010 16:39, James Kosin a écrit :
> Everyone,
> 
> Since, a AT91_EMAC_TUND only happens when the transmitter is unable to
> transfer the frame in time for a frame to be sent.  It makes sense to
> RETRY the packet in this condition in the ISR.
> Or would this overcomplicate a simple task?
>                 ... see below ...
> 
...

> 
> ...
> I do know there needs to be a bit more code then to handle the
> successful case below this; but, this is enough to understand what I am
> talking about.  The UNDERRUN error should happen infrequently and in
> ideal circumstances not happen at all.
>  


If this happens once in a while, why do you want driver to retry the transmit ?
