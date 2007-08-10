Return-Path: <linux-kernel-owner+w=401wt.eu-S941647AbXHJTdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941647AbXHJTdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939698AbXHJTcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:32:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938172AbXHJTcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:32:43 -0400
Message-ID: <46BCBD57.3030406@zytor.com>
Date: Fri, 10 Aug 2007 12:32:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mikko Rapeli <mikko.rapeli@iki.fi>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: early boot lockup with 2.6.23-rc1
References: <20070808223120.GA2286@nalle> <46BAC14E.9040604@zytor.com> <20070809182316.GA2289@nalle> <20070809194348.GA2287@nalle> <46BB94B1.9020307@zytor.com> <20070810163324.GA1916@nalle> <46BC962B.9030209@zytor.com> <20070810192030.GB1916@nalle>
In-Reply-To: <20070810192030.GB1916@nalle>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikko Rapeli wrote:
> On Fri, Aug 10, 2007 at 09:45:31AM -0700, H. Peter Anvin wrote:
>> Let me get this straight... "edd=skipmbr" boots fine, but commenting out
>> the call to query_edd() didn't?  Could you please try that (and, I
>> guess, only that), and make sure everything necessary is rebuild.
>>
>> 2.6.23-*rc2* you say boots fine with "edd=skipmbr", but not without?
> 
> Yes, vanilla 2.6.23-rc2 with edd=skipmbr boots fine.

Could you please describe your hardware configuration, in particular:

- what BIOS are you using;
- what disks, floppies, CD-ROMs, USB drives, etc are in your system;
- are any of them RAIDed;
- what device and bootloader are you using for boot.

	-hpa
