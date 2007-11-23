Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbXKWK1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbXKWK1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbXKWK12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:27:28 -0500
Received: from grex.cyberspace.org ([216.86.77.194]:23495 "EHLO
	grex.cyberspace.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbXKWK11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:27:27 -0500
Date: Fri, 23 Nov 2007 05:27:27 -0500
From: Roopesh <roopesh@cyberspace.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Roopesh <roopesh@cyberspace.org>, linux-kernel@vger.kernel.org
Subject: Re: MMC/SD: Write operation in invalid states by borken cards.
Message-ID: <20071123102727.GA4804@grex.cyberspace.org>
References: <20071108082410.GA1875@grex.cyberspace.org> <20071110115119.7944db28@poseidon.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071110115119.7944db28@poseidon.drzeus.cx>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

:---------- Original Message ----------
:
:From:  Pierre Ossman [drzeus-list@drzeus.cx]
:To  :  To Roopesh
:Sub :  Re: MMC/SD: Write operation in invalid states by borken cards.
:Sent:  Sat, Nov 10, 2007 at 05:51:19AM EST

:     On Thu, 8 Nov 2007 03:24:10 -0500
:     Roopesh <roopesh@cyberspace.org> wrote:
:     
:     >  Hi, 
:     > 
:     >  If a write operation fails, shouldnt we still check for the card 
:     >  state to be 'ready to accept next data'?
:     > 
:     >  This question is because I have noticed that some (broken) cards 
:     >  fail the write command, and the immediately issued subsequent 
:     >  commands also fail since the card state was never checked before 
:     >  sending these commands.
:     >  (There was a discussion about these cards at the thread: "MMC: 
:     >  CRC Errors with 2GB cards)
:     > 
:     
:     I'm confused. Didn't the previous fix solve your problems?

 I am sorry I couldnt respond in time, and also for creating the 
 confusion.  The previous fix did solve my problem.  However, if 
 for some other reason the card goes into an invalid state and a  
 write command fails, shouldnt we still check for the card state 
 before sending the next IO command?

:     Rgds
:     -- 
:          -- Pierre Ossman
:     
:       Linux kernel, MMC maintainer        http://www.kernel.org
:       PulseAudio, core developer          http://pulseaudio.org
:       rdesktop, core developer          http://www.rdesktop.org

