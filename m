Return-Path: <linux-kernel-owner+w=401wt.eu-S1751745AbZG3Sfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbZG3Sfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 14:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZG3Sfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 14:35:53 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23231 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZG3Sfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 14:35:52 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: tiago.vignatti@nokia.com
Subject: Re: [PATCH 2/3] vga: drops a documentation regarding the VGA arbiter
Date: Thu, 30 Jul 2009 12:35:50 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1247759311-6254-1-git-send-email-tiago.vignatti@nokia.com> <200907281325.51077.bjorn.helgaas@hp.com> <20090729085229.GA27252@tubao.research.nokia.com>
In-Reply-To: <20090729085229.GA27252@tubao.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301235.50712.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009 02:52:29 am Vignatti Tiago (Nokia-D/Helsinki) wrote:
> On Tue, Jul 28, 2009 at 09:25:50PM +0200, Bjorn Helgaas wrote:
> > On Thursday 16 July 2009 09:48:30 am Tiago Vignatti wrote:
> > > Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
> > > ---
> > >  Documentation/vgaarbiter.txt |  197 ++++++++++++++++++++++++++++++++++++++++++
> > >  1 files changed, 197 insertions(+), 0 deletions(-)
> > >  create mode 100644 Documentation/vgaarbiter.txt
> > 
> > I think the documentation update should be part of the same patch
> > that adds the functionality.  Then the docs will always match
> > the code.
> 
> I don't think some "normal" kernel developer will need such document.
> 
> Looks like we're doing nice cuts (well, Dave is) on this patch and coming in a
> state that people won't need to understand in deep things related with VGA
> arbiter before doing hacks with DRM/PCI drivers. Moreover, the vgaarb.h is
> pretty well readable :)

I guess I didn't make my point very well :-)  I haven't even looked at
the code, so I'll take your word for the fact that it's readable without
extra documentation.

My point was that if you add a feature "X" and you add documentation
for "X", both should be in a single patch so the logically related things
are all in one commit.

Bjorn
