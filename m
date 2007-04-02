Return-Path: <linux-kernel-owner+w=401wt.eu-S965888AbXDBVM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965888AbXDBVM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965889AbXDBVM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:12:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965888AbXDBVM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:12:58 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: virtualization@lists.linux-foundation.org
Subject: Re: A set of "standard" virtual devices?
Date: Mon, 2 Apr 2007 23:12:39 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <46116E12.5070206@goop.org>
In-Reply-To: <46116E12.5070206@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704022312.39195.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> How would that work in the case where virtualized guests don't have a
> visible PCI bus, and the virtual environment doesn't pretend to emulate
> a PCI bus?

If they emulated one with the appropiate device 
then distribution driver auto probing would just work transparently for them.

-Andi
