Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYDCLWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYDCLWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 07:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYDCLWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 07:22:11 -0400
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:1276 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972AbYDCLWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:22:10 -0400
Message-ID: <47F4CBF2.8020802@superbug.co.uk>
Date: Thu, 03 Apr 2008 13:22:10 +0100
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Tim Ricketts <tr@earth.li>, Michael Smith <msmith@xiph.org>,
       linux-kernel@vger.kernel.org, Andy Wingo <wingo@fluendo.com>,
       tglx@linutronix.de
Subject: Re: gettimeofday() jumping into the future
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>	<Pine.LNX.4.64.0803302210060.3056@falcon.foo> <87r6dr8iq3.fsf@basil.nowhere.org> <47F4C3C2.8030004@superbug.co.uk>
In-Reply-To: <47F4C3C2.8030004@superbug.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Courtier-Dutton wrote:
> than half of the max value cycle_now can have, one can take a very
> simple approach.
> Treat the cycle_now, cycle_last value as signed.
> If they have same sign, do the comparison as unsigned.
> If they have different signs, do the comparision as signed.
>
> James
>
Sorry,
 >Treat the cycle_now, cycle_last value as signed.
 >If they have same sign, do the comparison as unsigned.
 >If they have different signs, do the comparision as signed.
is wrong.


