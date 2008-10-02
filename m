Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYJBXg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYJBXg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbYJBXfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:35:18 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:46784 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbYJBXfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :face:mime-version:content-type:content-transfer-encoding;
        b=hMNi2KN/f6iuViCHPmxb9eF9OSn+2IzI7N2wcbVqUkzrlP76FS7apvr//m49C+xKIp
         Re6v0ZR8ynAO9cBlc0t/KCA2GhCq9HOzaCUjvhZmg36WlDOZEiuaRrX2t4dVf6HDAaeT
         /5hihkqkZGm8FAl7rsePf+0cc2YgiG1JSsqME=
Date: Thu, 2 Oct 2008 18:35:03 -0500
From: Jay Cliburn <jcliburn@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Jay Cliburn <jcliburn@gmail.com>, xiong.huang@atheros.com,
       csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: atl2 network driver status
Message-ID: <20081002183503.73674682@osprey.hogchain.net>
In-Reply-To: <20081002182943.0264f7fa@osprey.hogchain.net>
References: <20081002230246.GA11570@kroah.com>
	<20081002181731.6b8f563d@osprey.hogchain.net>
	<20081002232148.GA20003@kroah.com>
	<20081002182943.0264f7fa@osprey.hogchain.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
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

On Thu, 2 Oct 2008 18:29:43 -0500
Jay Cliburn <jcliburn@gmail.com> wrote:

> On Thu, 2 Oct 2008 16:21:48 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Oct 02, 2008 at 06:17:31PM -0500, Jay Cliburn wrote:
> > > On Thu, 2 Oct 2008 16:02:46 -0700
> > > Greg KH <greg@kroah.com> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > In looking for drivers to add to drivers/staging/ I ran across
> > > > the atl2 driver that is currently in the Fedora and Ubuntu
> > > > kernel trees.
> > > > 
> > > > This driver doesn't look to be scheduled for inclusion in the
> > > > upstream netdev git tree for submission for 2.6.28, is there any
> > > > reason why it is still out-of-the-tree?
> > > 
> > > Hi Greg,
> > > 
> > > It's in net-next-2.6.
> > > 
> > > http://marc.info/?l=linux-netdev&m=122144021209242&w=2
> > 
> > Nice, so that means it's going to be in 2.6.28?
> 
> I think so.  As I understand it, net-next-2.6 is Dave Miller's git
> tree for stuff destined for 2.6.28.

Yep, here it is: Dave's description of his two main trees.

So atl2 will be in 2.6.28.



Date: Sat, 19 Apr 2008 17:35:10 -0700 (PDT)
From: David Miller <davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org
Subject: New GIT net tree naming...



Based upon feedback from Andrew and others I'm now starting
to use a new naming scheme for my GIT trees:

For changes against Linus's current tree:

   master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git

For development meant to be merged in the next merge
window we have:

   master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git

Andrew/Stephen, let me know if this works for you.  This way
the tree names will never change.
--
To unsubscribe from this list: send the line "unsubscribe netdev" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
