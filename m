Return-Path: <linux-kernel-owner+w=401wt.eu-S932775AbXBVAve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbXBVAve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbXBVAve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:51:34 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:36645 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932775AbXBVAvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:51:33 -0500
X-Sasl-enc: ha9BTOoo1mRszuFOIAB9Kj8vOSFU5fOtT+sbzEJoNvN/ 1172105572
Date: Wed, 21 Feb 2007 22:51:22 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
Message-ID: <20070222005122.GA7928@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com> <20070219000412.acad13de.akpm@linux-foundation.org> <1171876788.6046.3.camel@localhost.localdomain> <877iub9mu2.fsf@sycorax.lbl.gov> <1172097718.5790.29.camel@localhost.localdomain> <20070221231706.GA3336@khazad-dum.debian.net> <1172103159.5790.45.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172103159.5790.45.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Richard Purdie wrote:
> I have a thinkpad with Intel GM graphics ;-). I need it to work so I try
> not to experiment too much on it. I've just tried the ibm-acpi driver
> and it doesn't work well :-(.

2.6.21-rc, or 2.6.20?  If it is in 2.6.21, could you give me a report of how
it fares on 2.6.20?

> * 'cat brightness' != 'cat actual_brightness' upon bootup (doesn't have

Hmm, I see this in 2.6.20 too.  And brightness is the one that is buggy.  I
will look into it.

> * 'echo 0 > brightness' lowered the intensity but by a level or two, not
> set it to level 0. A couple of more attempts and it did jump from 7 -> 1
> and so on, it seems erratic.

I know it used to work fine before 2.6.20.  Let me check...  works fine on a
T43, 2.6.20 (Radeon X300).  I need more data to fix it :-)

> actual_brightness always seems to be correct, as does brightness so it
> looks like its not updating the hardware correctly.

Well, if you have the ACPI video module loaded, unload it.  Does it work
now?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
