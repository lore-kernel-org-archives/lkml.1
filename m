Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYJNLAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYJNLAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYJNLAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:00:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:47104 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbYJNLAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:00:19 -0400
Date: Tue, 14 Oct 2008 20:00:09 +0900
To: nico@chdir.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB problem on x86_64: nommu_map_single() issue?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081014104500.GB1252@sd-5945.dedibox.fr>
References: <20081014072045.GA1252@sd-5945.dedibox.fr>
	<200810141148.48220.oliver@neukum.org>
	<20081014104500.GB1252@sd-5945.dedibox.fr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081014200016H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 12:45:00 +0200
Nicolas Bareil <nico@chdir.org> wrote:

> Hi Oliver,
> 
> On Tue, Oct 14, 2008 at 11:48:47AM +0200, Oliver Neukum wrote:
> > > On 2.6.27, I can't use any USB device (mass storage, mouse) anymore on my x86_64 system, the devices
> > > are not detected: lsusb returns nothing except the hub.
> > 
> > Is this a regression? Did it work on earlier kernels?
> 
> Yes this is a regression: USB works in 2.6.26.x with (almost) the same configuration.

With old kernels, you can find something like the following line in
the boot log?

PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
