Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYIQAlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYIQAlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 20:41:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYIQAkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 20:40:52 -0400
Received: from fmailhost05.isp.att.net ([204.127.217.105]:56061 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYIQAkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 20:40:51 -0400
X-Originating-IP: [70.157.0.38]
Date: Tue, 16 Sep 2008 19:40:47 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, tglx@tglx.de, mingo@elte.hu,
       linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Warning/Oops report of the week of September 16th, 2008
Message-ID: <20080916194047.0d23eb92@osprey.hogchain.net>
In-Reply-To: <20080916092206.6342c498@infradead.org>
References: <20080916092206.6342c498@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEV2dXOAgYNxSD+aemaal42A
 gIBqYV2UU07Ik5GXfoFMRTdbKiVwAAACbUlEQVQ4jXXTzWvbMBQAcG3EZsmt0Owc3pgNPo1oxNFt
 pQnEN3Wrs3UnkdXq5tOwIdq9Pci3gUqJexo55KC/cs9O/dHBRIiMfpb03rNE4v800jxIQRzsXPEP
 jDwndhNelo9/ngE/SFdKmZQnfOT0YSSlQBKLiJBDH6w9SPwlp5evpduDr9biQqkV8Rh7p4NRNSO1
 4BHhpjLpIK2gWksIgl0LPLCHoBIcX6dp2kGKMYnfGJnjIFungZeuHA6dhSvqLXrA1zJmVKayCu1w
 DKuGAU+WZRRCsLdBFXgLl2Sw3N2ZEJDAn3VwEV9FK12YUGW+yqlIWiD30U5rbSi2efGuhRfxEXRB
 8e+uJE/AL5z78xrqVg6aBHlMTj9V7x/RJOMGHHI11ItVUW+B0JakkGPcUsJNHuY7/ZA04X4xwQ/D
 3I0FGgaT8iFponoJ26F+sNbu51O7l7QHHtNTbxMc5o/W+kw0S31Ub5i+pQBq/hjYPVPbJ/ic/aoC
 pbTQtxlAvvnZgNod89Y4D2sFXpMHZWU1yHb6Ft+g2aTJY84iY2iY4ySGmWdvmxlDprHkCgd1yDRV
 bXVfFQiZjyuyaU5p1pZkTbXBbxRagAyU2rZfcH2tTQ7+FpNQ4Ofb7lxdFzTHDGqAvHdEv0cIezi2
 be+0vzdUqawaDSATHfB7itGiIfrQu2p8UQOOooHTh5lUPn6lva/qQrWwQpCUTv08hGe3dkU9KWmJ
 Z2EGpAeDFc3kN8oMNbNJ/AzMFERUhjmehB7ws6XBTTnfeOXT9T/C9dn4HEshpPWIjDvgi5Px2U0G
 Hl7dzaQHg8U4Xn6oa4g3vVnqLz3ribDLdyFmAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 09:22:06 -0700
Arjan van de Ven <arjan@infradead.org> wrote:


> Not yet fixed issues
> ====================
> 
> Rank 1: dev_watchdog (warning)
> 	Reported 263 times (495 total reports)
> 	Network card timeout; this error is currently not specific
> enough, a patch is pending to get this reported per driver, with some
> luck this gets merged soon. This warning was last seen in version
> 2.6.27-rc6, and first seen in 2.6.26-rc3. More info:
> http://www.kerneloops.org/searchweek.php?search=dev_watchdog

Some of these are undoubtedly from the atl1 driver, and many of those
from that driver are probably from me personally as I've poked around
trying to isolate the cause.  I sent a patch yesterday to Alexey
Dobriyan (who's also been experiencing it) that seems to quash the
warnings, so hopefully we're near resolution.  On my own development
system I recently turned off kerneloops, so at least *my* contribution
to the list will diminish.  :)

Jay
