Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYC0Ltl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYC0Ltl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbYC0Ltb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:49:31 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:42510 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbYC0Ltb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:49:31 -0400
Date: Thu, 27 Mar 2008 12:49:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080327114923.GA6589@basil.nowhere.org>
References: <20080320111429.GA14764@elf.ucw.cz> <20080321135418.GB2346@one.firstfloor.org> <20080326102151.GB18965@elf.ucw.cz> <20080326130052.GF2170@one.firstfloor.org> <20080326225407.GA9378@elf.ucw.cz> <20080326230017.GA21017@elte.hu> <20080327084231.GC25876@elf.ucw.cz> <20080327095949.GA5771@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327095949.GA5771@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 Mar 2008 11:42:45.0697 (UTC) FILETIME=[ACB40310:01C88FFF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ...this sounds like it needs to be done during resume, too, no?

This is only a workaround for BIOS that don't set up an aperture,
but yes if they don't do that it is likely needed on resume too.

You would need to add a resume handler to aperture.c

-Andi
