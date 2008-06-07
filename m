Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbYFGPBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbYFGPBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbYFGPBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:01:44 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3923 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603AbYFGPBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:01:43 -0400
Date: Sat, 7 Jun 2008 10:30:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rog?rio Brito <rbrito@ime.usp.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080607143051.GA3096@tuxdriver.com>
References: <20080601193000.GA3056@ime.usp.br> <20080606162324.GB635@tuxdriver.com> <20080607005227.GA1739@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080607005227.GA1739@ime.usp.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 09:52:27PM -0300, Rog?rio Brito wrote:
> First of all, thanks John for taking the time to reply to my
> message.
> 
> On Jun 06 2008, John W. Linville wrote:
> > On Sun, Jun 01, 2008 at 04:30:01PM -0300, Rogério Brito wrote:
> > > I have an iBook G3 600MHz combo (late 2001 model, powerpc) with a USB
> > > wireless card rt2x00 that doesn't work.
> > > 
> > > I just compiled a fresh 2.6.26-rc4 kernel and it can't get a lease from
> > > the access point, even though it is able to see the access point.
> > > 
> > > The userland here is Debian unstable (sid) and I can perform some of the
> > > steps in the direction of configuring the interface. For instance, the
> > > following works (I am using wep as the encryption system with other systems
> > > running under Linux, but, unfortunately, EVEN disabling encryption for the
> > > sake of the tests doesn't help here):
> (...)
> > > (Here, it is unable to grab an IP addess from the access point)
> > 
> > You should set the key _before_ setting the essid.
> 
> Thanks, but that unfortunately doesn't seem to help. :-(
> 
> I have taken dmesg "snapshots" of my system together with many other
> information regarding how it is configured and I put it at my
> homepage, at <http://www.ime.usp.br/debug/>.

404

> >From what I am seeing, it looks like the bug mentioned in
> <http://bugzilla.kernel.org/show_bug.cgi?id=9388>, but I don't get the
> stack trace that is present there and I'm just trying to use WEP
> instead of WPA or anything fancier.

Did you apply this patch?

	http://bugzilla.kernel.org/attachment.cgi?id=14384

John
-- 
John W. Linville
linville@tuxdriver.com
