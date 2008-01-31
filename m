Return-Path: <linux-kernel-owner+w=401wt.eu-S933514AbYAaMgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514AbYAaMgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764530AbYAaMgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:36:44 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10838 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764437AbYAaMgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:36:42 -0500
Message-ID: <47A1C0A5.7090303@panasas.com>
Date: Thu, 31 Jan 2008 14:35:49 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Matthew Wilcox <matthew@wil.cx>
CC: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] GDTH driver not working after upgrade to 2.6.24
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47A1ABF8.4050408@upb.de>
In-Reply-To: <47A1ABF8.4050408@upb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 Jan 2008 12:35:51.0823 (UTC) FILETIME=[D0A641F0:01C86405]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31 2008 at 13:07 +0200, Sven Köhler <skoehler@upb.de> wrote:
>> Yes the gdth driver passed an open hart surgery in kernel 2.6.24. The bad thing
>> about it is that all three of the Coders that did that did not have any HW to work
>> on. One of them is me. We did cry for tester for a long time but no one came forward.
> 
> All i'd like to ask is WHY!?
> WHY such a big open heart surgery?
> OK, you have your reasons.
> 
>> Could you test patches for us? first thing would be to enable debug output patch below.
> 
> The machine is still production. It will be replaced by a 64bit system 
> with an AACRAID card some time in the future. Then, i could maybe test 
> patches on the old machine. But unfortunatly, it's not my machine. It's 
> just administrated by me. And i don't know, what's exactly is the future 
> of it.
> 
>> If you absolutely need a 2.6.24 kernel, + gdth in a production system you could
>> checkout the 2.6.23 driver and compile. The old driver will work the same in 2.6.24.
>> It will not however even compile in 2.6.25-rcx.
> 
> I see. Thanks for the hint. Would be an alternative. Actually, i don't 
> need 2.6.24 - but if something security related is fixed, then i'm not 
> able to move on to 2.6.24. And i'm using Gentoo. There's not really a 
> kernel maintained by the distribution.
> 
>> If any one wants to send me a card that uses the gdth driver, I will be very happy
>> to debug this card, and return it once I'm done.
> 
> I don't think, it's a seperate card, that i could send you. It's some 
> 19" rack server with such a card on-board, i think.
> 
> 
> So it don't see much opportunity for me to test patched and stuff :-(
> 

Thanks, Perhaps someone else then. 
Anyone with gdth HW that can test patches?
Your lspci said: "Intel Corporation RAID Controller" Matthew
is there a gdth card lying around in an Intel lab near you?

James do we need to mark gdth BROKEN for 2.6.24 and higher?

Boaz
