Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbXLUDlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbXLUDlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXLUDle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:41:34 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1781 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752968AbXLUDle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:41:34 -0500
Message-ID: <476B35BC.8060204@myri.com>
Date: Thu, 20 Dec 2007 22:40:44 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: tcamuso@redhat.com, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       Prarit Bhargava <prarit@redhat.com>, bnagendr@redhat.com
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <fa.HvUNJ45qy60H427u0v9fNt3Gc7E@ifi.uio.no> <fa.uuzqvr64HFsgxfiWwhEmE16Di6c@ifi.uio.no> <fa.zhxdNN/1rfQhfJLVmdGBjvKYrCM@ifi.uio.no> <fa.z1qlON6DA9ubBPFdrEcaFTMgYOY@ifi.uio.no> <fa.U/SCC1Gvd3nSOpkMu5vcsSPYyPE@ifi.uio.no> <fa.d8kGTkzOZH22bXRIRiakqgOPBM4@ifi.uio.no> <476B0C58.4030703@shaw.ca> <476B185D.3000409@redhat.com> <476B21D8.2030602@shaw.ca>
In-Reply-To: <476B21D8.2030602@shaw.ca>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2007 9:15 PM, Robert Hancock wrote:
>>
>> Suggested Workaround
>>
>> It is strongly recommended that system designers do not connect the
>> AMD-8132 and devices that use extended
>> configuration space MMIO BARs (ex: HyperTransport-to-PCI Express®
>> bridges) to the same processor
>> HyperTransport link.
>>
>> Fix Planned
>> No
>
> That does sound fairly definitive. I have to wonder why certain system
> designers then didn't follow their strong recommendation..



Just curious, do you know of any system where that recommendation was
not followed? On all motherboards where I have seen a AMD-8131 or a
AMD-8132, they were alone on their hypertransport link, and other
"northbridges" (more precisely hypertransport to pci-express or
pci-whatever, often nvidia) with a "MMCONFIG BAR" where on one of the
other available hypertransport links in the system.


Loic

