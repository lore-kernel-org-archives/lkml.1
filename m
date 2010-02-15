Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab0BONAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 08:00:01 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:37508 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab0BONAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 08:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PHPqA1rmDdlUvSE4LaOHN2jRCznAz+VAUs9CwOzt/1+cEA7D+H7+M6nZAzr6eg8NRF
         M4fnFiSbeC+BPXz2eQP0iNxMPwhI0/XqxZ9Ks8ZUua85KF/1mgnk9opMHr6dZni+vo/2
         4GtWw3L5J4HbyBHlz+1TOoSQ3tzWWqUsfP7JA=
Message-ID: <4B79454B.1030805@gmail.com>
Date: Mon, 15 Feb 2010 07:59:55 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v5 3/7] tcp: harmonize tcp_vx_rcv header length assumptions
References: <4B793CAA.2030902@gmail.com> <4B793DFC.8070306@gmail.com> <20100215124842.GF21783@one.firstfloor.org>
In-Reply-To: <20100215124842.GF21783@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Mon, Feb 15, 2010 at 07:28:44AM -0500, William Allen Simpson wrote:
>> Harmonize tcp_v4_rcv() and tcp_v6_rcv() -- better document tcp doff
>> and header length assumptions, and carefully compare implementations.
> 
> I didn't fully understand that new comment:
> 
> /* nf_reset(skb); in ip6_input.c ip6_input_finish() */
> 
That's part of the harmonization.  IPv4 has a nf_reset() in this code
position.  I asked on the list where IPv6 did the same thing, so that
the difference could be documented.  The information was provided by
Patrick McHardy.  If someday somebody actually finishes merging the
two functions, that's the only actual difference.


> Overall you can add a 
> 
> Reviewed-by: Andi Kleen <andi@firstfloor.org>
> 
Thanks, hopefully as applied.
