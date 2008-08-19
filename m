Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYHSSrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYHSSrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYHSSrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:47:41 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22486 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYHSSrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:47:40 -0400
Date: Tue, 19 Aug 2008 12:47:38 -0600
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: jbarnes@virtuousgeek.org, matthew@wil.cx, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: create device, function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080819184738.GE18842@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, jbarnes@virtuousgeek.org,
	matthew@wil.cx, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080818202100.GE23155@ldl.fc.hp.com> <20080818231954.GA6080@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818231954.GA6080@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gary Hade <garyhade@us.ibm.com>:
> On Mon, Aug 18, 2008 at 02:21:00PM -0600, Alex Chiang wrote:
> > Create convenience symlinks in sysfs, linking slots to
> > devices and functions, and vice versa. These links make it
> > easier for users to figure out which devices actually live in
> > what slots.
> 
> This looks it would be quite useful but the symlinks are not
> adjusted during hot-add and hot-remove operations (e.g. stale
> symlinks persist after hot-remove and new symlinks are not
> created in response to hot-add) so it could confuse more than
> help on systems with PCI hotplug support.

Hi Gary,

Yes, you're right. Willy's original version of the patch had
symmetric functions in pci_release_dev/pci_scan_device, which I
didn't include because I didn't understand why we needed that
code.

Now I understand. :)

Thanks for pointing it out. I'll work on this for v2.

/ac

