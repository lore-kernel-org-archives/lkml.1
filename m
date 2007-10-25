Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbXJYFia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbXJYFia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXJYFh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:37:59 -0400
Received: from ns3.mountaincable.net ([24.215.0.13]:41199 "EHLO
	ns3.mountaincable.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbXJYFh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:37:58 -0400
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
From: Ryan Lortie <desrt@desrt.ca>
To: "Zephaniah E. Hull" <warp@aehallh.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20071024153508.GG26573@aehallh.com>
References: <20070609084800.GR6362@aehallh.com>
	 <d120d5000710231110u79ea11a8p38f1fc4654a7fac2@mail.gmail.com>
	 <1193191094.32696.2.camel@moonpix.desrt.ca>
	 <200710232333.08306.dmitry.torokhov@gmail.com>
	 <20071024153508.GG26573@aehallh.com>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 01:37:34 -0400
Message-Id: <1193290654.15893.2.camel@moonpix.desrt.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-24-10 at 11:35 -0400, Zephaniah E. Hull wrote:
> We need a way to, at the absolute minimum, unbind the keyboard from the
> text console.  The current solution sucks for things like rfkill.
> 
> I'm not convinced that Ryan's fix is any better, but just saying that X
> should open the console and ignore the characters is simply not an
> option as far as I am concerned for X.

Can you think of any other way to separate things like rfkill/evdev from
things like the text console that's less hacky than my 'priority'
scheme?

Cheers


