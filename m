Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbZFMPu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbZFMPu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 11:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZFMPut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 11:50:49 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:4014 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbZFMPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 11:50:49 -0400
From: James Cloos <cloos@jhcloos.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, "Linux-MIPS" <linux-mips@linux-mips.org>,
       Florian Fainelli <florian@openwrt.org>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/8] add lib/gcd.c
In-Reply-To: <20090613162802.6c212505@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Sat, 13 Jun 2009 16:28:02 +0100")
References: <200906041615.10467.florian@openwrt.org>
	<m38wjwz5ur.fsf@lugabout.jhcloos.org>
	<20090613162802.6c212505@lxorguk.ukuu.org.uk>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.92 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Sat, 13 Jun 2009 11:50:15 -0400
Message-ID: <m3ocssw2sw.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Alan" == Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> Would the binary gcd algorithm not be a better fit for the kernel?

Alan> Could well be the shift based one is better for some processors only.

Very likely, I suspect.

And the version of the euclid algo in that patch is better than most
references that I've seen.  (q=a/b;r=a%b; is common, probably because
the texts use the same algo for computing the continued fraction.)

In any case, I do not have the hardware to do any statistically
significant testing; the closest I could do would be a speed test
on hera, which I expect would be discouraged.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
