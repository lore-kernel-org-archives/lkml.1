Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389Ab0AYIKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab0AYIKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 03:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665Ab0AYIKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 03:10:38 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:32928 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0AYIKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 03:10:38 -0500
Message-ID: <4B5D51E6.5090601@gmail.com>
Date: Mon, 25 Jan 2010 09:10:14 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Curt Sampson <cjs@starling-software.com>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Problems Receiving UDP Broadcasts on Some Versions of Linux
References: <20100125072749.GG21419@analytic.cynic.net>
In-Reply-To: <20100125072749.GG21419@analytic.cynic.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 25 Jan 2010 09:10:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 25/01/2010 08:27, Curt Sampson a écrit :
> I'm posting this here because it smells as if it may be something
> a where a kernel network code developer might just say, "oh yeah,
> obviously your problem is this."
> 
> I'm not subscribed to this list, so please cc me on any replies. (The
> Mail-followup-to header may do this automatically for you.)
> 
> The short summary is that on two very similar servers on the same
> network, an application that listens for broadcast UDP packets on a
> given port works fine on the Ubuntu 8.04/Linux 2.6.24-26-server box but
> does not receive the packets on the Ubuntu 9.04/Linux 2.6.28-17-server
> box. I have confirmed that tcpdump sees identical packets being received
> on both hosts.
> 
> Did something change between these two kernel revisions that I need to
> listen differently?
> 
> Full details, including sample code, are available at:
> 
>   http://stackoverflow.com/questions/2130563/udp-broadcast-reception-problems-with-ubuntu-9-04-but-not-8-04
> 
> Thanks for any help you can give me. Even if you're not sure, but have
> clues I should consider following up, feel free to e-mail me. I'm
> also happy to take pointers to kernel code I should read, if there's
> enlightenment there.
> 
> cjs

Hi Curt

Could you post a sample of tcpdump trafic you receive on the 9.04 host, and your network config ?
"ifconfig -a"
