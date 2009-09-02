Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbZIBL75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbZIBL75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZIBL74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:59:56 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:49518 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZIBL7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:59:55 -0400
Date: Wed, 2 Sep 2009 13:59:45 +0200
From: Raphael Manfredi <Raphael_Manfredi@pobox.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.30.5] Diagnosing an IDE lockup with SMART long tests
Message-ID: <20090902115945.GA7261@chram.org>
References: <6661.1251822466@nice.ram.loc> <4A9DF3E9.9090309@gmail.com> <20090902111927.GA4590@chram.org> <200909021351.33803.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909021351.33803.linux@rainbow-software.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ondrej Zary:
: On Wednesday 02 September 2009, Raphael Manfredi wrote:
: > Quoting Robert Hancock:
: > > It's most likely a bug in the IDE code somewhere, but realistically the
: > > most effective course of action would likely be to switch from the old
: > > IDE drivers and use libata instead. The IDE code doesn't receive that
: > > much testing these days, and it's really hard to debug (as you've seen,
: > > the debugging output is rather atrocious).
: >
: > I gave it a shot anyway.  Converting to PATA was surprisingly
: > straighforward.
: >
: > Anyway, I now get the following when running SMART long tests on /dev/sda:
: >
: >   ata1: lost interrupt (Status 0x50)
: >
: > And the machine hangs...  So I'm back to square one.
: > How do I prevent lockups on the system when running SMART long tests?
: 
: What drive is that? Isn't that an IBM drive with buggy firmware?

Ah, you're right.  It's not an IBM, it's an Hitashi, bought shortly
after IBM sold out their disk activity.

Here's hdparm -i with extra spaces removed:

 Model=HDS722512VLAT80, FwRev=V33OA60A, SerialNo= VN343EC4C6JM8M

Is this a buggy firmware revision?

Raphael
