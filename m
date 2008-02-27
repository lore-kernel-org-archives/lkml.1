Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbYB0UKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbYB0UKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbYB0UKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:10:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39917 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbYB0UKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:10:10 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C5C340.7080302@s5r6.in-berlin.de>
Date: Wed, 27 Feb 2008 21:08:32 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Kristian Hoegsberg <krh@bitplanet.net>
Subject: Re: [PATCH 1/2] firewire: endianess fix
References: <20080220220326.GA22328@uranus.ravnborg.org> <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de> <tkrat.9e19fa31951506af@s5r6.in-berlin.de> <200802271458.28401.jwilson@redhat.com>
In-Reply-To: <200802271458.28401.jwilson@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Works just fine with the Apple UniNorth controller in my powerbook in cursory 
> testing.

Could you remove the OHCI1394_HCControl_postedWriteEnable flag from 
fw-ohci.c::ohci_enable() and test without and with the endianess patch?
-- 
Stefan Richter
-=====-==--- --=- ==-==
http://arcgraph.de/sr/
