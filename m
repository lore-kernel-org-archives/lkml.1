Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXDCI3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXDCI3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 04:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933115AbXDCI3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 04:29:11 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:29243 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012AbXDCI3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 04:29:10 -0400
From: Christian Borntraeger <borntrae@de.ibm.com>
To: Andi Kleen <ak@suse.de>
Subject: Re: A set of "standard" virtual devices?
Date: Tue, 3 Apr 2007 10:29:06 +0200
User-Agent: KMail/1.9.5
Cc: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <46116E12.5070206@goop.org> <200704022312.39195.ak@suse.de>
In-Reply-To: <200704022312.39195.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704031029.06819.borntrae@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 23:12, Andi Kleen wrote:
> 
> > How would that work in the case where virtualized guests don't have a
> > visible PCI bus, and the virtual environment doesn't pretend to emulate
> > a PCI bus?
> 
> If they emulated one with the appropiate device 
> then distribution driver auto probing would just work transparently for
> them. 

Still, that would only make sense for virtualized platforms that usually have 
a PCI bus. Thinking about seeing a PCI device on ,lets say, s390 is strange.

Christian
