Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbZFHSrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbZFHSrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbZFHSrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:47:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57441 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750698AbZFHSrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:47:00 -0400
Date: Mon, 8 Jun 2009 19:48:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gil Beniamini <gil.beniamini@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SOCK_RAW does not receive broadcast (with VLAN unless PROMISC)
Message-ID: <20090608194817.3baba827@lxorguk.ukuu.org.uk>
In-Reply-To: <91ac27070906081105x30171bedra10d244d382a6934@mail.gmail.com>
References: <91ac27070906081105x30171bedra10d244d382a6934@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 21:05:25 +0300
Gil Beniamini <gil.beniamini@gmail.com> wrote:

> Dear Linux Experts,
> 
> My application is using PF_PACKET and SOCK_RAW in order to receive all
> Ethernet packets for the machine-unicast MAC plus all broadcast
> packets (like ARP broadcast).

You need to specify which network card. If you include that information
then the best place to ask is netdev@vger.kernel.org. It does indeed
sound like you may be seeing a driver funny.

Alan
