Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbXHCQhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbXHCQhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXHCQgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:36:52 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:60805 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbXHCQgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:36:51 -0400
Date: Fri, 3 Aug 2007 12:36:40 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Grega Fajdiga <Gregor.Fajdiga@guest.arnes.si>
cc: linux-kernel@vger.kernel.org
Subject: Re: CD/DVD-ROM: ide vs. libata
In-Reply-To: <46B30D8A.2090607@guest.arnes.si>
Message-ID: <Pine.LNX.4.64.0708031231190.3978@lancer.cnet.absolutedigital.net>
References: <46B30D8A.2090607@guest.arnes.si>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Grega Fajdiga wrote:

> Hello, LKML,
> 
> I'm wondering if the old ide-cd from the ide subsystem is still
> necessary to get a CD/DVD-ROM working or is there a libata driver
>   available already,

Check the ATA menu in the kernel config to see if your controller has a 
driver. If so, enable it, enable SCSI cdrom support, and disable the old 
IDE stuff. If all goes well you should get /dev/sr0 which will be your new 
cdrom device.

Cheers,
-- 
Cal Peake

