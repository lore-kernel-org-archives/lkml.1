Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbXKJKvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbXKJKvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 05:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXKJKvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 05:51:23 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:45513 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbXKJKvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 05:51:22 -0500
Date: Sat, 10 Nov 2007 11:51:19 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Roopesh <roopesh@cyberspace.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MMC/SD: Write operation in invalid states by borken cards.
Message-ID: <20071110115119.7944db28@poseidon.drzeus.cx>
In-Reply-To: <20071108082410.GA1875@grex.cyberspace.org>
References: <20071108082410.GA1875@grex.cyberspace.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007 03:24:10 -0500
Roopesh <roopesh@cyberspace.org> wrote:

>  Hi, 
> 
>  If a write operation fails, shouldnt we still check for the card 
>  state to be 'ready to accept next data'?
> 
>  This question is because I have noticed that some (broken) cards 
>  fail the write command, and the immediately issued subsequent 
>  commands also fail since the card state was never checked before 
>  sending these commands.
>  (There was a discussion about these cards at the thread: "MMC: 
>  CRC Errors with 2GB cards)
> 

I'm confused. Didn't the previous fix solve your problems?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
