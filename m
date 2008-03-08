Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbYCHKhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbYCHKhS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 05:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYCHKhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 05:37:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYCHKhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 05:37:04 -0500
Message-ID: <47D26A00.7050308@zytor.com>
Date: Sat, 08 Mar 2008 11:27:12 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: devzero@web.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       rick@vanrein.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
References: <182234194@web.de> <20080304132724.GB32383@elte.hu>
In-Reply-To: <20080304132724.GB32383@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * devzero@web.de <devzero@web.de> wrote:
> 
>>> What is wrong with mem=exactmap?
>> probably no ordinary user knows how to use it instead of badram?
>> http://lists.opensuse.org/opensuse/2007-04/msg00501.html
>>
>> someone please show us how to use that instead of badram or how this 
>> can replace what badram does.
> 
> as i said it in another reply to this thread, it would be perfectly 
> acceptable for upstream to merge an easier to use boot option - be that 
> badmem=addr$size or excludemem=addr$size. Please send a patch :-)
> 

It already called:

	memmap=addr$size


... and has been implemented for years.  Does the badram patch do 
anything different?  (And yes, I agree the $/@/# is ugly.)

	-hpa
