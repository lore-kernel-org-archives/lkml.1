Return-Path: <linux-kernel-owner+w=401wt.eu-S933568AbXGTS1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbXGTS1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbXGTS10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:27:26 -0400
Received: from ns2.suse.de ([195.135.220.15]:34421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbXGTS1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:27:25 -0400
From: Andreas Schwab <schwab@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andi Kleen <ak@novell.com>, Arthur Jones <arthur.jones@qlogic.com>,
       Vasily Tarasov <vtaras@openvz.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, linux-arch@vger.kernel.org
Subject: Re: build fix for x86_64...
References: <617E1C2C70743745A92448908E030B2A01FA46A9@scsmsx411.amr.corp.intel.com>
	<46A0EAC8.9020203@zytor.com> <jezm1rq8gz.fsf@sykes.suse.de>
	<46A0F4AC.50809@zytor.com>
X-Yow: YOW!!  Now I understand advanced MICROBIOLOGY
 and th' new TAX REFORM laws!!
Date: Fri, 20 Jul 2007 20:27:01 +0200
In-Reply-To: <46A0F4AC.50809@zytor.com> (H. Peter Anvin's message of "Fri\, 20
	Jul 2007 10\:45\:16 -0700")
Message-ID: <je7iov2aoa.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> struct foo {
> 	u32 bar;
> 	compat_u64 baz;
> 	u32 quux;
> };

compat_u64 is only for use in CONFIG_COMPAT code.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
