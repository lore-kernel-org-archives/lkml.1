Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbYBAMdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbYBAMdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbYBAMdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:33:11 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50312 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388AbYBAMdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:33:10 -0500
X-Sasl-enc: +YVjsaQikjnbV/t7X8YOFcxsciDN2X68uym6uIru8Zmq 1201869187
Message-ID: <47A311F2.2020603@ladisch.de>
Date: Fri, 01 Feb 2008 13:34:58 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
CC: list linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.14 snd_hda_intel problem
References: <47A25998.1000501@eyal.emu.id.au> <47A2DEAC.7000004@ladisch.de> <47A2EEBD.3050705@eyal.emu.id.au>
In-Reply-To: <47A2EEBD.3050705@eyal.emu.id.au>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eyal Lebedinsky wrote:
> My /etc/modprobe.conf now contains:
> 	alias snd-card-0 snd-hda-intel
> 	options snd-card-0 index=0
> 	options snd-hda-intel index=0
> and and I should add
> 	options snd-usb-audio index=1
> right?

Yes.

> Any idea why has this changed between the two minor kernel revisions though?

Probably nothing.  The exact loading order of USB and PCI driver is
somewhat random.


Regards,
Clemens
