Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYBQD5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYBQD5O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbYBQD46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 22:56:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46848 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbYBQD45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 22:56:57 -0500
Message-ID: <47B7B081.8050306@zytor.com>
Date: Sat, 16 Feb 2008 19:56:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kernel/{exit.c, signal.c, power/process.c}: replace
 !likely(x) by likely(!x)
References: <47B70810.5030608@tiscali.nl> <47B732EF.4050504@zytor.com> <47B79D0D.2070808@keyaccess.nl>
In-Reply-To: <47B79D0D.2070808@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 16-02-08 20:01, H. Peter Anvin wrote:
>> Roel Kluin wrote:
>>> Not entirely sure who to send this to
>>> ---
>>> Replace !likely(x) by likely(!x)
>>
>> Whoa...
>>
>> Are you sure this is correct?
>>
>> !likely(x) is equivalent to unlikely(!x)
> 
> Not with respect to its value I believe? likely(x) == !!(x), and 
> unlikely(!x) == !!(!x) = !x, so conditions work out differently?

You missed one ! sign:

!likely(x) == !!!(x) == unlikely(!x) == !!(!(x))

	-hpa
