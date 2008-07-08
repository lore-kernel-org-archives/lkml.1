Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYGHWUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYGHWUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYGHWUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:20:09 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:3085 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbYGHWUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:20:08 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Pavel Machek <pavel@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Date: Tue, 8 Jul 2008 22:19:18 +0000
Subject: RE: [PATCH][resubmit] HP iLO driver
Thread-Topic: [PATCH][resubmit] HP iLO driver
Thread-Index: AcjhRHdRb/PBFYPmTTqlQQyD+GbKWwAAJkCA
Message-ID: <CF70AA892F109448AEA269483B3A983903BB8CF552@G1W1215.americas.hpqcorp.net>
References: <20080623160052.GA7616@ldl.fc.hp.com>
 <20080627191458.GA10872@ucw.cz>
 <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net>
 <20080707160658.GB1794@elf.ucw.cz>
 <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
 <20080708072152.GD1761@elf.ucw.cz> <20080708073818.GA14245@elf.ucw.cz>
 <CF70AA892F109448AEA269483B3A983903BB8CEFC4@G1W1215.americas.hpqcorp.net>
 <20080708215002.GA18195@elf.ucw.cz>
In-Reply-To: <20080708215002.GA18195@elf.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Could you provide the list of commands (at least) so we can be more
> concrete?

Unfortunately, I don't believe that I can.  We reviewed this internally,
and the question of documentation was raised.  The hardware teams did
not approve disseminating the ABI.  To be clear, we understand what we
are doing by releasing the driver as GPLv2, the actual functionality
of communicating with iLO was okayed for release.  But releasing the
specifics of what we can send was not approved.

> Yes, I believe we do want to have 30 commands it kernel, because it
> will allow same userland to work on HP machines, AMD machines, etc...

We sell AMD :)

> (I assume management processors have pretty similar functionality
> accross vendors, right?)

I can't speak for other vendors.

>> It seems much cleaner to keep the kernel interface simple and opaque
>> (ie read/write), and handle the details of the commands in user
>> space. From my limited understanding, I thought that was a common
>> goal here: move what you can to userspace.
>
> We are not _that_ extreme. Yes, keep stuff in userspace is important,
> but "hide hardware differences" is more important goal.

That seems like a larger question/goal.  Giving users some consistent
interfaces to do stuff would be nice, but I'd really like to handle this
driver on its own.
