Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYIDNls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYIDNls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYIDNlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:41:40 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58240 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbYIDNlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 09:41:39 -0400
Date: Thu, 4 Sep 2008 09:41:39 -0400
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: How to add the Asus R1F to asus-laptop.c?
Message-ID: <20080904134139.GU12474@csclub.uwaterloo.ca>
References: <20080903170649.GF12476@csclub.uwaterloo.ca> <200809031859.28203.alistair@devzero.co.uk> <20080903201620.GS12474@csclub.uwaterloo.ca> <200809032132.34967.alistair@devzero.co.uk> <20080903203954.GT12474@csclub.uwaterloo.ca> <71cd59b00809032348h7874167ckae1ea3d1ddab1e1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71cd59b00809032348h7874167ckae1ea3d1ddab1e1c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 08:48:03AM +0200, Corentin Chary wrote:
> Hi,
> Currently I've no internet connection, so I'm depend off the hotspot I
> can found when I'm close to my windows
> Anyway, my connection will be activated soon, so please poke me again monday.
> I'ts true that I should take a look at sf.net patchs ...
> Anyway, this laptop should work with asus-laptop oO.
> modprobe asus-laptop gives you "No such device" ?

Using 2.6.26, I get no such device and the driver refuses to load.
asus-acpi loads fine and does its job.

I will try the patch and see if that helps.  I was rather surprised that
it didn't load, so I started doing acpi dumps and looking at the driver
to see if I could figure out what it used to determine things.  It
looked to me like it checks if the hotkey registration works, which by
the looks of it it isn't doing at the moment.

-- 
Len Sorensen
