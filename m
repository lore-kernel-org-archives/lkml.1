Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbXDDRua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbXDDRua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXDDRu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:50:29 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52032 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbXDDRu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:50:28 -0400
Date: Wed, 4 Apr 2007 12:50:23 -0500
To: David Lang <david.lang@digitalinsight.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org, dwmw2@infradead.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404175023.GV4922@austin.ibm.com>
References: <20070404024400.56d016e1@the-village.bc.nu> <Pine.LNX.4.63.0704031817020.21680@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0704031817020.21680@qynat.qvtvafvgr.pbz>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 06:23:07PM -0700, David Lang wrote:
> 
> people working with ~50 serial ports or ethernet ports aren't useing stock 
> distros anyway.

???  For "big servers", Suse SLES and RedHat RHEL are the defacto choices, 
with Ubuntu a rising star. It doesn't get much more stock than that.

> > Which is also another reason for building the "all serial devices"
> > mapping by using udev, as it can provide multiple simultaneous views. The
> > serial console unfortunately rather breaks that approach as Dave pointed
> > out
> 
> I would reverse this. instead of having a bunch of different names and then 
> requiring a tool to create sane names from them, start off with a nice nameing 
> scheme and have a tool that tells you the under-the-covers details.

Except that udev already exists, and is widely deployed by most distros
to handle the "sane naming" problem. In particular, "sane naming"
becomes hard if devices can be hotplugged, whether they are usb or pci
(e.g. a usb-to-serial converter).

--linas

