Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYIRFKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYIRFKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 01:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYIRFKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 01:10:15 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:8176 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbYIRFKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 01:10:14 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap" messages
Date: Wed, 17 Sep 2008 23:10:00 -0600
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200809091250.08620.elendil@planet.nl> <200809091140.25597.bjorn.helgaas@hp.com> <48C6C0ED.2000409@keyaccess.nl>
In-Reply-To: <48C6C0ED.2000409@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809172310.01580.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 12:31:09 pm Rene Herman wrote:
> On 09-09-08 19:40, Bjorn Helgaas wrote:
> 
> > If the PCI device isn't fully initialized, it doesn't seem right to
> > check it for resource conflicts.  But I don't know how to tell that.
> 
> His pci_resource_start() values are 0. How about just checking for that?

Frans, can you test Rene's patch?  I think it will solve the problem
you're seeing, and if so, we should put it in for 2.6.27.  But I'd like
to have your "Tested-by" first.

(Jesse, Rene's patch just skips the PNP/PCI resource conflict check
for things with pci_resource_start() == 0.)

Thanks,
  Bjorn
