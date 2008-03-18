Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYCRB0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYCRB0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 21:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYCRB0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 21:26:30 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:55479 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYCRB03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 21:26:29 -0400
Message-ID: <47DF1A7E.30809@keyaccess.nl>
Date: Tue, 18 Mar 2008 02:27:26 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
CC: David Brownell <david-b@pacbell.net>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200803171400.40045.david-b@pacbell.net> <47DEFD85.1050706@keyaccess.nl> <200803171700.26274.david-b@pacbell.net> <alpine.LFD.1.00.0803180317050.11560@nev.ubzr>
In-Reply-To: <alpine.LFD.1.00.0803180317050.11560@nev.ubzr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-03-08 01:24, Lev A. Melnikovsky wrote:

> DB> On Monday 17 March 2008, Rene Herman wrote:
> DB> > +       case PCI_VENDOR_ID_VIA:
> DB> > +               if (pdev->device == 0x3104 && pdev->revision >= 0x60) {
> DB> Unless you have specific docs from VIA saying that this register
> DB> isn't revision-specific (at least in the sense that all revisions
> DB> after 0x60 define that bit in that way), this should probably be a
> DB> switch on pdev->revision and just include the known-safe revisions.
> May I suggest this should be a module parameter? Because a side effect is 
> a USB slow-down, which may be more important for somebody...

If the 10us is a EHCI specification, I'd personally think not. But if need 
be...

Rene.
