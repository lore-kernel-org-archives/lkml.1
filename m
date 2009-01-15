Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbZAOM64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbZAOM64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbZAOM6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:58:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56479 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbZAOM6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:58:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH RFC v5] net: add PCINet driver
Date: Thu, 15 Jan 2009 13:58:33 +0100
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       shemminger@vyatta.com, netdev@vger.kernel.org
References: <20090107195052.GA24981@ovro.caltech.edu> <200901131842.54688.arnd@arndb.de> <20090115001251.GA10745@ovro.caltech.edu>
In-Reply-To: <20090115001251.GA10745@ovro.caltech.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151358.34250.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/bxEdHF8h0bXYildcOe6pO6sEIQW7QU2/j66V
 o+emc5qZ0g03duSV9WZMlC9H8nuVqqQ6QnHKRY8C4xDq6pMqwd
 M3KXm+rSR+OlMDhcdq+3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Ira Snyder wrote:

> The only problem with that is that you cannot route interrupts from the
> DMA controller over PCI with the PowerPC core running. Which makes it
> mostly useless for this case.

If the host supports MSI, you can simply program the DMA controller to
write the correct message to the inbound address of the MSI interrupt
controller!

All modern host systems should have MSI, as this is required by the
PCIe specification, but it still somewhat limits the choice of your
hosts.

	Arnd <><
