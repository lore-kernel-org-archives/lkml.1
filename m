Return-Path: <linux-kernel-owner+w=401wt.eu-S940207AbXHJQpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940207AbXHJQpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765174AbXHJQpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:45:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908AbXHJQpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:45:40 -0400
Message-ID: <46BC962B.9030209@zytor.com>
Date: Fri, 10 Aug 2007 09:45:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mikko Rapeli <mikko.rapeli@iki.fi>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: early boot lockup with 2.6.23-rc1
References: <20070808223120.GA2286@nalle> <46BAC14E.9040604@zytor.com> <20070809182316.GA2289@nalle> <20070809194348.GA2287@nalle> <46BB94B1.9020307@zytor.com> <20070810163324.GA1916@nalle>
In-Reply-To: <20070810163324.GA1916@nalle>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikko Rapeli wrote:
> 
> Nice, 2.6.23-rc2 with edd=skipmbr boots just fine.
> 
>> Anyway, if that doesn't solve it:
>>
>> In main() in arch/i386/boot/main.c, please comment out everything from
>> query_mca() to query_edd(), inclusively.
> 
> This didn't help.
> 

Let me get this straight... "edd=skipmbr" boots fine, but commenting out
the call to query_edd() didn't?  Could you please try that (and, I
guess, only that), and make sure everything necessary is rebuild.

2.6.23-*rc2* you say boots fine with "edd=skipmbr", but not without?
Did you try the above commenting-out on rc2?

Just don't want to be chasing ghosts.

	-hpa
