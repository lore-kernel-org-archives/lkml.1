Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbXAWKRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbXAWKRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 05:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932938AbXAWKRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 05:17:14 -0500
Received: from mail.first.fraunhofer.de ([194.95.169.2]:55541 "EHLO
	mail.first.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbXAWKRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 05:17:13 -0500
To: linux-kernel@vger.kernel.org
Date: Tue, 23 Jan 2007 10:17:06 +0000 (UTC)
From: Soeren Sonnenburg <kernel@nn7.de>
Message-ID: <ep4nb2$mh2$1@fortknox.intranet.wo.rk>
Organization: Local Intranet News
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
References: <1169542768.5537.11.camel@cocoduo>
Subject: Re: 2.6.19.2 sky2/acpi crashes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 08:59:28 +0000, Lionel Landwerlin wrote:

> Hi,
> 
> I'm running a macbook with a Marvell ethernet controller, and I have a
> lots of freezes when using the ethernet controller under a load of
> ~100K/s. Since I'm running a 2.6.19.2 kernel, I'm able to get some
> report from the kernel. Here they are :

I am also having trouble with the sky2 module, though I've not yet seen a
oops, the driver stopped working after some heavy traffic (copying some G
of data). Only rmmod sky2; modprobe sky2 resolved this. (I am also on
2.6.19.2 but I've seen this happen on 2.6.20-rcX too).

Soeren
