Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbXFLFYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbXFLFYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXFLFYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:24:38 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:18666 "EHLO
	asav13.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbXFLFYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:24:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmYmAAbLbUZKhRO4UGdsb2JhbACHM4gMAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: linux-joystick@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] input: make 2 macros in gameport.c TSC-aware
Date: Tue, 12 Jun 2007 01:24:35 -0400
User-Agent: KMail/1.9.3
Cc: Miltiadis Margaronis <mmargaron@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
References: <alpine.BSF.0.99.0706110624150.5014@micmac.localdomain>
In-Reply-To: <alpine.BSF.0.99.0706110624150.5014@micmac.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120124.36623.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 11 June 2007 00:12, Miltiadis Margaronis wrote:
> 
>   This makes DELTA and GET_TIME in drivers/input/gameport/gameport.c
>   similar to the ones in drivers/input/joystick/analog.c . Worked on
>   2.6.22-rc4-git2.
> 

I was told with the introduction of tickless kernels and such the best
option is to convert gameport to use hires timers.

-- 
Dmitry
