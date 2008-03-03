Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbYCCSkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbYCCSkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYCCSkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:40:00 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:24476 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751031AbYCCSj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:39:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eufX7byyMZRMMpqrfespNJkwl7VZCuVwzT2rcGL0tgspLz1DY7MqKKs5Vku9ycUWgkSOxpVRhUjPIr8dmHces6pO6oTNOeo/hL4J9SY7xHtK+Op2qYDbX3ifm5Vf0cCOTNm0ic9KAzczG00PNHjM05Zx3jYriLBBoWmEDDH3c4M=  ;
X-YMail-OSG: tPUFHhcVM1lXDZ9HGnEgECth6hsgp69Ze.98eo7xNu_weTJ.DiWUBa2Lt5GNeJ.bco7N9zMyJA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
Subject: Re: High resolution timers on AT91SAM926x
Date: Mon, 3 Mar 2008 10:39:57 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       tglx@linutronix.de
References: <200803011457.40857.david-b@pacbell.net> <d6c8ef150803030226m75f68bffvfa20feba9133b247@mail.gmail.com>
In-Reply-To: <d6c8ef150803030226m75f68bffvfa20feba9133b247@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031039.57909.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008, Bosko Radivojevic wrote:
> thank you for the reply. But, I'm getting pretty strange behavior.

Presumably you got different results when your Kconfig
enabled a HRT/NO_HZ capable clockevent source, instead
of just the PIT?

CONFIG_ATMEL_TCLIB=y
CONFIG_ATMEL_TCB_CLKSRC=y
CONFIG_ATMEL_TCB_CLKSRC_BLOCK=0
