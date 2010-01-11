Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150Ab0AKV5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab0AKV5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449Ab0AKV5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:57:33 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:35672 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab0AKV5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:57:32 -0500
Subject: Re: [PATCH 00/14] pci: update pci bridge resources
From: Patrick Keller <patrick.keller@hp.com>
Reply-To: patrick.keller@hp.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Chiang, Alexander" <achiang@hp.com>,
       "Helgaas, Bjorn" <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 14:57:00 -0700
Message-ID: <1263247020.2877.10.camel@pLaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2009-12-22 at 23:02 +0000, Yinghai Lu wrote:

> 2. hotplug:
> BIOS separate IO range between several IOHs, and on some slots, BIOS assign
> the resource to every bridge. (8M) but when insert one card that big resource,
> the card can not get resource. because kernel will not touch the bridge
> resource.

> Thanks
> 
> Yinghai
> 

These patches appear to fix logical hotplug so that it is functional
again.  I think we're good.

Tested-by: Patrick Keller <patrick.keller@hp.com>

