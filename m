Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbYKQR3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbYKQR3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYKQR3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:29:11 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:4077 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbYKQR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:29:10 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Date: Mon, 17 Nov 2008 12:28:24 -0500
Message-Id: <20081117171433.M54175@bobcopeland.com>
In-Reply-To: <491DCA12.3000304@gmail.com>
References: <491506DB.1070000@gmail.com> <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com> <4918A8C5.3050607@gmail.com> <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com> <491B17B3.204@gmail.com> <20081114034730.GA9482@hash.localnet> <491DCA12.3000304@gmail.com>
X-Mailer: OpenWebMail 2.53 
X-OriginatingIP: 149.101.1.135 (bob)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 20:57:22 +0200, Maxim Levitsky wrote
> Bob Copeland wrote:
> > On Wed, Nov 12, 2008 at 07:51:47PM +0200, Maxim Levitsky wrote:
> >>>> Why it doesn't accept new mac?, can this be fixed?
> >> Any update on mac changer status?
> > 
> > As a first stab, can you try this patch?  This sets the address on
> 
> Works almost perfectly,
> 
> when I load the module, then run macchanger, and then ifconfig wlan0 up
> then it works, if I do an ifconfig up once, then ifdowning the interface, it
> doesn't.

Yeah, I had actually written more for that patch originally, but didn't 
post it because it was a bit more invasive.  I think the issue is just that 
start() shouldn't program the mac at all and let add_interface handle that.
I'll post a revised patch in a day or two.

> The noise floor calibration issue bites me again and gain.
> When it shows up, usually card continues to work, but at next assotiation
> stops working.

Does this help?
http://marc.info/?l=linux-wireless&m=122570806813839&w=2

> Transfer speeds are unusually low:

You can try using the minstrel rate control algorithm, it may help.

-- 
Bob Copeland %% www.bobcopeland.com


