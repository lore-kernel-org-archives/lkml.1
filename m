Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175Ab0AMJCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0AMJCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863Ab0AMJCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:02:33 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54713 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754509Ab0AMJCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:02:32 -0500
X-Sasl-enc: GB0gn5++VASygaggOV0PvxuDxc8vDZFl9q+qPqFE3GM5 1263373351
Message-ID: <4B4D8C24.6060007@imap.cc>
Date: Wed, 13 Jan 2010 10:02:28 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.7) Gecko/20100104 SeaMonkey/2.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de
Subject: Re: Can we remove pci_find_device() yet?
References: <20100108112236.462a3da2.sfr@canb.auug.org.au> <20100108044646.GC6611@suse.de> <4B4B802A.2010709@imap.cc> <20100111200136.GA29955@suse.de> <4B4CA666.1050505@imap.cc> <20100112173947.GA7784@suse.de>
In-Reply-To: <20100112173947.GA7784@suse.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 2010-01-12 18:39 schrieb Greg KH:
> On Tue, Jan 12, 2010 at 05:42:14PM +0100, Tilman Schmidt wrote:
[...]
>> Many of the calls to pci_find_device() have checkpatch problems
>> which of course do not go away by just substituting another
>> function name, so I would be obliged to restructure all those
>> call sites by hand for the sake of "not introducing new code
>> with checkpatch problems". BTDT.
> 
> No you would not, don't be crazy.  Modfying a single line to rename a
> function from one thing to another could never be decreed as a "don't
> add bad code".  And if someone says it is, well, you just found someone
> who doesn't know what they are doing :)

Ok. I do hope you are right, and my extrapolation from past
experience was wrong.

> Please continue with this idea, it's sane, and valid.

Alright, will do. Patch will follow later today, SCJ. Let's see
what the checkpatch police will say.

Regards,
Tilman

- -- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAktNjCQACgkQQ3+did9BuFsmMwCfReQ/mHQUApkpRWJZIG16PmvI
vO4Anj/A4kSwddg+RZV2Uj5LVUNlsBD3
=LxhW
-----END PGP SIGNATURE-----
