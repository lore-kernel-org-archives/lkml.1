Return-Path: <linux-kernel-owner+w=401wt.eu-S1766014AbXHQVa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766014AbXHQVa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762134AbXHQV3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:29:39 -0400
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:30222 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760608AbXHQV3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:29:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=VLvF3YOFrp8TwxvClQzbg9UYUGuL6deUuJFV+ZslCs/+9ptOAjC0SeGXMXFAGi+MLWEd1bLqIEKW4vKqGLMGMdGb/m10YgUs1+wg/7sQoIb5Tv8eK8DFQ+r9IrVHF/7Kvs0CTSeY28VOVvAFaljaZ+j/spq1debst+Hc/x3AWs4=  ;
X-YMail-OSG: 4YPkTD4VM1nYuJk.YthKU5QKHPPRWTZApZRIxiWXx.ShuZ8d52kMiGKnn_q8rkw8_aYkC2g3o1GMdKa8_J3otPwMqiRzqEXuY1lMdBkg9hRkTKMzGHSDOZT9u0cmCr3M9sekPs45J9EGhts-
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Fri, 17 Aug 2007 14:15:33 -0700
User-Agent: KMail/1.9.6
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com> <200708171309.25529.david-b@pacbell.net> <8bd0f97a0708171319q71b5a117v8882f4fb70d2dc43@mail.gmail.com>
In-Reply-To: <8bd0f97a0708171319q71b5a117v8882f4fb70d2dc43@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708171415.33805.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Mike Frysinger wrote:

> as Michael pointed out, in the Blackfin world we tend to keep things
> very dynamic as we have dev systems which allow for dropping in of
> optional cards at will, so doing this in the bootloader is way too
> inflexible.

That's the tradeoff:  optimize for development boards, or
instead for more fixed-function product boards.


> oh, and another [smallish] data point.  the Blackfin processor has a
> small bootrom on it that could be likened to a very micro bios.  so
> it's possible to actually boot the linux kernel straight without a
> boot loader.  send the kernel over the UART to a Blackfin and watch it
> go go go :)

That's not uncommon, although I'm more used to seeing the
on-chip ROMs relying on a second stage loader for stuff like
getting memory and other clocks going at optimal speeds,
and loading "big" images (that won't fit on-chip SRAM).

- Dave

