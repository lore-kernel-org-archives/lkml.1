Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbZDIFYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbZDIFYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760009AbZDIFYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:24:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55424 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759979AbZDIFYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:24:36 -0400
Date: Wed, 8 Apr 2009 23:23:44 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: "John Stoffel" <john@stoffel.org>
Cc: Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org, zaitcev@redhat.com
Subject: Re: usb_mon oops Re: tcpdump crashes 2.6.29.1 (and 2.6.29-rc5)
Message-Id: <20090408232344.afed8103.zaitcev@redhat.com>
In-Reply-To: <18908.42166.404232.721757@stoffel.org>
References: <18906.49779.243047.207639@stoffel.org>
	<20090407120022.GA6519@ff.dom.local>
	<18907.28788.965069.573489@stoffel.org>
	<20090407130403.e0061a8d.zaitcev@redhat.com>
	<18908.42166.404232.721757@stoffel.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 09:20:54 -0400, "John Stoffel" <john@stoffel.org> wrote:

> Well I think that usbmon is probably at fault here for trusting
> drivers too much and not doing any sanity checking. []

By the way, please send me a full dmesg from the affected system
and kernel. Any post-boot dmesg will do: I only want to see if
IOMMU is active, where the aperture is, and if 0x20a15cc0 is a
valid physical address.

-- Pete
