Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYCRAbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYCRAbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 20:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYCRAbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 20:31:09 -0400
Received: from gw1.kapitza.umos.ru ([217.67.113.134]:38518 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752140AbYCRAbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 20:31:08 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2008 20:31:08 EDT
Date: Tue, 18 Mar 2008 03:24:59 +0300 (MSK)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: David Brownell <david-b@pacbell.net>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
In-Reply-To: <200803171700.26274.david-b@pacbell.net>
Message-ID: <alpine.LFD.1.00.0803180317050.11560@nev.ubzr>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200803171400.40045.david-b@pacbell.net> <47DEFD85.1050706@keyaccess.nl> <200803171700.26274.david-b@pacbell.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  On Mon, 17 Mar 2008 at 11:26pm, Rene Herman wrote:

RH> And, as usual, I can not reach Lev as some mailer along the way is
RH> telling me his address is unroutable.
I'm here, don't worry :-)

  On Mon, 17 Mar 2008 at 4:00pm, David Brownell wrote:

DB> On Monday 17 March 2008, Rene Herman wrote:
DB> > +šššššššcase PCI_VENDOR_ID_VIA:
DB> > +šššššššššššššššif (pdev->device == 0x3104 && pdev->revision >= 0x60) {
DB> Unless you have specific docs from VIA saying that this register
DB> isn't revision-specific (at least in the sense that all revisions
DB> after 0x60 define that bit in that way), this should probably be a
DB> switch on pdev->revision and just include the known-safe revisions.
May I suggest this should be a module parameter? Because a side effect is 
a USB slow-down, which may be more important for somebody...

-L
