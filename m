Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbZLAVPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbZLAVPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 16:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZLAVPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 16:15:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:43092 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbZLAVPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 16:15:01 -0500
Message-ID: <4B158720.9030008@kernel.org>
Date: Tue, 01 Dec 2009 13:14:08 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Alex Williamson <alex.williamson@hp.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Always set prefetchable base/limit upper32	registers
References: <20091130214954.10845.23072.stgit@debian.lart> <20091201000332.GD24539@lackof.org> <20091201001942.GF24539@lackof.org> <1259640654.10482.44.camel@2710p.home> <20091201195523.GA16534@lackof.org> <4B157F23.4040701@kernel.org> <20091201205910.GB16534@lackof.org>
In-Reply-To: <20091201205910.GB16534@lackof.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Tue, Dec 01, 2009 at 12:40:03PM -0800, Yinghai Lu wrote:
> ...
>>> I assumed Yinghai's objection was based on a specific problem he had
>>> seen with writing upper32 register. Bjorn asked the right question.
>>> If there isn't a specific problem, I'd prefer AW's simpler patch.
>> we just should not touch that register if the HW only support 32bit pref mmio.
> 
> Why not?
> 
> I agree the PCI-PCI spec defines how to determine if a PCI Bridge supports
> 64-bit Pref MMIO (using upper32 - or not). But spec also doesn't prohibit
> writing to a read-only register.  Writing this Read-Only register so far
> hasn't caused any problems.

if we can find out that is 32bit mmio pref, why waste cycle to write value to them?

YH
