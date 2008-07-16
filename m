Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbYGPJyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbYGPJyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYGPJxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:53:55 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:47708 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbYGPJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:53:55 -0400
Message-ID: <487DC4FA.4050505@csr.com>
Date: Wed, 16 Jul 2008 10:52:58 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
       linux-usb <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Dropping WUSB/UWB from my patch queue
References: <20080630180009.GA30833@kroah.com> <4871E9F0.60608@csr.com> <20080715155313.GA3075@kroah.com> <487CE2E7.90505@csr.com> <20080716054911.GA9806@kroah.com>
In-Reply-To: <20080716054911.GA9806@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2008 09:52:58.0639 (UTC) FILETIME=[BA5CF9F0:01C8E729]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 
> Ugh, so, what will end up getting merged?  Anything that people can
> actually use?  :)

To summarize what is planned to be merged and what is being postponed.

Merged:

* core UWB stack.
* WHCI radio controller driver
* core WUSB support.
* WHCI host controller driver
* CBAF driver

i.e., a functioning WUSB stack for WHCI (PCI-based) cards.

Postponed:

* HWA radio controller driver
* Wire Adapter core (for HWAs and DWAs).
* HWA host controller
* WLP support
* i1480 firmware download driver.
* i1480 WLP driver.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
