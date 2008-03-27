Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYC0Fuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYC0Fuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 01:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYC0Fud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 01:50:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49368 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYC0Fuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 01:50:32 -0400
Date: Thu, 27 Mar 2008 06:53:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080327055349.GC29105@one.firstfloor.org>
References: <20080320111429.GA14764@elf.ucw.cz> <20080321135418.GB2346@one.firstfloor.org> <20080326102151.GB18965@elf.ucw.cz> <20080326130052.GF2170@one.firstfloor.org> <20080326225407.GA9378@elf.ucw.cz> <20080326230017.GA21017@elte.hu> <20080326230500.GB9378@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326230500.GB9378@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> (it is GPLed) ...but it is totally untested, and probably same fix
> needs to go to all the agp drivers...?

No the other AGP drivers don't have IOMMU functionality.

Also there still need to be Kconfig changes or alternatively 
extracting the suspend/resume code to another file that is selected
by both AGP and IOMMU.

-Andi
