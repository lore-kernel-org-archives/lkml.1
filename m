Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbYCPQYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbYCPQYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 12:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYCPQY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 12:24:26 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:2504 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbYCPQYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 12:24:25 -0400
Message-ID: <47DD499B.1050503@panasas.com>
Date: Sun, 16 Mar 2008 18:23:55 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: Andreas Westin XX <andreas.xx.westin@ericsson.com>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl and statics
References: <6006DAC0B81F85439BC960F36F929CDFB5F5EE@eseldmw101.eemea.ericsson.se>	 <1205422989.3621.22.camel@tara.firmix.at>  <47DD21E1.2080505@panasas.com> <1205676819.3815.48.camel@gimli.at.home>
In-Reply-To: <1205676819.3815.48.camel@gimli.at.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2008 16:23:58.0719 (UTC) FILETIME=[234398F0:01C88782]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 16, 2008, 16:13 +0200, Bernd Petrovitsch <bernd@firmix.at> wrote:
> On Son, 2008-03-16 at 15:34 +0200, Benny Halevy wrote:
>> On Mar. 13, 2008, 17:43 +0200, Bernd Petrovitsch <bernd@firmix.at> wrote:
>>> On Don, 2008-03-13 at 16:09 +0100, Andreas Westin XX wrote:
>>> [....]
>>>> I ran checkpatch.pl on a piece of code I wrote and besides all the other
>>>> warnings/errors it complained about a static pointer being initialised
>>>> to NULL/0. I fixed it but I'm curious as to why this is not permitted ?
>>> Because "uninitialized" data is automatically initialized wit 0. An
>>> explicit initialization with 0/NULL wastes space in the kernel image.
>> gcc (at least version >= 4.1.2) seems to smarter than that. It
> 
> That's good news (and new to me too).
> 
>> doesn't seem to put data initialized to zero in the initialized data
>> segment but rather adds it to the uninitialized data. That said,
>> initializing statically allocated data to zero is superfluous in C
>> and should be avoided for style/elegance reasons as well.
> 
> Well, one can discuss endlessly about style and elegance ....

Heh, that's what checkpatch is all about, isn't it? :)
Real errors and warnings should be caught and reported by the compiler...

Benny

> 
> 	Bernd

