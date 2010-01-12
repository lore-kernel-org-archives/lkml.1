Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187Ab0ALQVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0ALQVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037Ab0ALQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:21:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab0ALQVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:21:07 -0500
Message-ID: <4B4CA157.8060906@zytor.com>
Date: Tue, 12 Jan 2010 08:20:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Pavel Machek <pavel@ucw.cz>, Karel Zak <kzak@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com> <20100111140255.GA1416@ucw.cz> <20100112071931.GA18822@logfs.org> <4B4C308C.6020804@zytor.com> <20100112093755.GB18822@logfs.org>
In-Reply-To: <20100112093755.GB18822@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 01:37 AM, Jörn Engel wrote:
> On Tue, 12 January 2010 00:19:24 -0800, H. Peter Anvin wrote:
>>
>> I believe for Smartmedia the FTL is done host side, but that there is a
>> standard-specified FTL (called CIS, Card Information System.)
>
> A CIS block/page is part of the FTL design.  Not sure whether it also
> lends its name to it.  I'll just take your word for it.
>
> Whether the FTL is done host side depends on the card reader and your
> definition of host side.  Most old card readers implemented it in the
> driver, but some newer ones prefer to export a usb mass storage
> interface, thereby not requiring any driver CD.
>

"Host side" in this case means "not on the card".  The electrical 
interface to Smartmedia is, indeed, raw NAND.

	-hpa
