Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719Ab0ALIUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0ALIUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510Ab0ALIUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:20:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38897 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0ALIUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:20:33 -0500
Message-ID: <4B4C308C.6020804@zytor.com>
Date: Tue, 12 Jan 2010 00:19:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Pavel Machek <pavel@ucw.cz>, Karel Zak <kzak@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com> <20100111140255.GA1416@ucw.cz> <20100112071931.GA18822@logfs.org>
In-Reply-To: <20100112071931.GA18822@logfs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 11:19 PM, Jörn Engel wrote:
> On Mon, 11 January 2010 15:05:42 +0100, Pavel Machek wrote:
>>
>> Flash has special mapping layer, and does not care (SD/MMC), or is a
>> raw nand and can't be used as block device (smartmedia).
> 
> Complete bullsh*t.  Smartmedia can (and arguably must) be used as a
> block device and all devices you listed do care about alignment.
> 

I believe for Smartmedia the FTL is done host side, but that there is a
standard-specified FTL (called CIS, Card Information System.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

