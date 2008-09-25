Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYIYX7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYIYX7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 19:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYIYX6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 19:58:55 -0400
Received: from fmailhost02.isp.att.net ([207.115.11.52]:39920 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbYIYX6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 19:58:54 -0400
X-Originating-IP: [74.251.44.253]
Date: Thu, 25 Sep 2008 18:58:49 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Chris Snook <csnook@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>, Kevin Hao <kexin.hao@windriver.com>,
       Jeff Garzik <jgarzik@redhat.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: remove LLTX in atl2 driver
Message-ID: <20080925185849.0df482e2@osprey.hogchain.net>
In-Reply-To: <48DC11F5.20900@redhat.com>
References: <1222302922-13200-1-git-send-email-kexin.hao@windriver.com>
	<48DBF4DD.8060908@redhat.com>
	<48DBFAB5.2010709@garzik.org>
	<48DC11F5.20900@redhat.com>
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

On Thu, 25 Sep 2008 18:34:29 -0400
Chris Snook <csnook@redhat.com> wrote:

> 
> I'm all in favor of removing legacy cruft.  I want to know a little
> more about it so we can remove it from the atl1 code as well.
> Ultimately most of this will be shared code.

Yes, LLTX can (and should) be removed from the atl1 code.  I had an
exchange with Herbert Xu and David Miller on LKML a few weeks ago, and
they gave me a few tips on how to do it, but I haven't yet had the
time.  What takes an experienced netdev warrior about a half hour to
implement unfortunately takes me days of after-dayjob time as I track
through all the calls that that are affected and test the modified
driver.

Now back to atl2...  I'd like to hear from Kevin also whether he tested
the LLTX removal.  I'm building the driver with his patch as we speak,
and I'll test it myself this weekend, but Kevin I'd still like to know
if you tested the patch.

Thanks,
Jay
