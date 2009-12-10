Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbZLJTZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbZLJTZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761454AbZLJTZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:25:19 -0500
Received: from swm.pp.se ([212.247.200.143]:44518 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761405AbZLJTZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:25:17 -0500
Date: Thu, 10 Dec 2009 20:25:23 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-scsi <linux-scsi@vger.kernel.org>
cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
In-Reply-To: <alpine.DEB.1.10.0912051116400.23464@uplift.swm.pp.se>
Message-ID: <alpine.DEB.1.10.0912102022460.23464@uplift.swm.pp.se>
References: <200909090414.41274.tfjellstrom@shaw.ca> <200909091030.13147.tfjellstrom@shaw.ca>  <4AA7F965.6020408@garzik.org> <4AF0CFE1.8050407@tomt.net>  <alpine.DEB.1.10.0912032214040.23464@uplift.swm.pp.se> <73e903670912031336n749c0bb4l5f2e46d5347e5875@mail.gmail.com>
  <alpine.DEB.1.10.0912041952370.23464@uplift.swm.pp.se> <73e903670912041108o32c28af3q5a61e5a2e33edd0a@mail.gmail.com> <alpine.DEB.1.10.0912051116400.23464@uplift.swm.pp.se>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Dec 2009, Mikael Abrahamsson wrote:

> When removing this extra option, it compiles with vanilla 2.6.32 just 
> fine. I crashes the same way as the ubuntu kernel when hot-plugging a 
> disk as well (this time I did it without gdm/x running and it oopses, 
> but unfortunately the highest part of the oops scrolled off). It's 100% 
> reproducible anyway, so basically the controller is a no-go in 2.6.31.6 
> and 2.6.32 both vanilla and ubuntu versions, both without and including 
> the nov09 mvsas patch (at least the original version of the patch as 
> posted). Different failure scenarios though... With the stock kernel the 
> controller seems to get stuck in writing and nothing more happens but at 
> least the machine doesn't crash and burn like it does with the 
> mvsas-patch.

Would it make sense for me to log this problem in bugzilla? There seems to 
be a similar issue with equal hw:

<http://bugzilla.kernel.org/show_bug.cgi?id=14534>

did these fixes ever go upstream? Are they scheduled to go into the 
stable rebuilds of 2.6.32 ? The patches mentioned in there, are these the 
ones I already tried that didn't solve my problem?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
