Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbYJ1BwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbYJ1BwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYJ1Bvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:51:49 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:38654 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYJ1Bvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:51:48 -0400
From: James Cloos <cloos@jhcloos.com>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       "David S. Miller" <davem@davemloft.net>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: radeonfb lockup in .28-rc (bisected)
In-Reply-To: <1225152347.8004.49.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Tue, 28 Oct 2008 11:05:47 +1100")
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	<1225152347.8004.49.camel@pasglop>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2008 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Mon, 27 Oct 2008 21:50:57 -0400
Message-ID: <m3prllij1j.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:23:081028:benh@kernel.crashing.org::MGJmZZWb4jmnye55:0000000000000000000000000000000000000BXjK
X-Hashcash: 1:23:081028:linux-kernel@vger.kernel.org::HnCVd4p7EZ03Y2f8:000000000000000000000000000000000Q5+H
X-Hashcash: 1:23:081028:torvalds@linux-foundation.org::YIulgA7QWDqWCrlT:00000000000000000000000000000000Bdt4
X-Hashcash: 1:23:081028:akpm@linux-foundation.org::1/0qutZOeEg9Kw5E:000000000000000000000000000000000000fW5G
X-Hashcash: 1:23:081028:khc@pm.waw.pl::FkhYNeRej3qH2Dn7:0000pUAJ
X-Hashcash: 1:23:081028:davem@davemloft.net::iu5K1w6IDOxq5RUI:0000000000000000000000000000000000000000002BM8
X-Hashcash: 1:23:081028:linux-fbdev-devel@lists.sourceforge.net::2+xQHtL/yztvV8KW:0000000000000000000000aefA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Benjamin" == Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

Benjamin> Annoying... Either I'm doing something wrong (which is always
Benjamin> possible) or we're hitting yet another fancy ATI bug (the M7
Benjamin> generation is known to be pretty bad in that area).

Yes, M7 does have its idiosyncrasies. :)

Benjamin> First, let's see if it's related to the imageblit. Can you
Benjamin> re-apply the reverted patch and apply this little hack on top
Benjamin> :

I'm starting a compile now.  It'll be a couple of hours until I can
reboot.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
