Return-Path: <linux-kernel-owner+w=401wt.eu-S936397AbXG0U75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936397AbXG0U75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764663AbXG0U7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:59:39 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:34370 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765321AbXG0U7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:59:38 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Fri, 27 Jul 2007 14:58:44 -0600
User-Agent: KMail/1.9.6
Cc: "Shaohua Li" <shaohua.li@intel.com>,
       "=?iso-8859-1?q?S=E9bastien?= =?iso-8859-1?q?_Dugu=E9?=" 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707271256.17025.bjorn.helgaas@hp.com> <86802c440707271335y29ca79ccq844b5cb457bd2314@mail.gmail.com>
In-Reply-To: <86802c440707271335y29ca79ccq844b5cb457bd2314@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271458.44391.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007 02:35:30 pm Yinghai Lu wrote:
> On 7/27/07, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > Can you give a more detailed example?  Maybe that would help me understand
> > the problem you're seeing.
> >
> > And why is udev not sufficient to give the NICs persistent names?
> 
> yes. NIC on node1 become the eth0 instead of eth2.

We aren't doing threaded probes or anything yet, so on a given
machine, device names should be deterministic.

Of course, if you reconfigure the machine, the driver may find
devices in a different order and name them something different.
I don't see a way to avoid that.

And couldn't we use udev to associate a fixed name with a MAC
address?  Then the user could use the same persistent name,
regardless of the order in which the driver found the devices.

Bjorn
