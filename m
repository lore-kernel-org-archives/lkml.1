Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYAQVuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYAQVuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbYAQVsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:48:23 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:43882 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759427AbYAQVsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:48:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Nph66ri491CpmmPfTw6HiC87ctvohxc1tkYlXNpbmVg1oVvMiIRJQOnG1h1S2Tf6xMFc/JzXOf5oAxe4gfzIXf4b9oCQxDEat0BsBtaW2zow/92CrUWDXpzyAY/8p/fxB/ebQtXITTL0A0LJdgV1D0DuCPb7k0pcDhyf0azeeCo=
Message-ID: <478FCD1F.4090704@gmail.com>
Date: Thu, 17 Jan 2008 22:48:15 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Zan Lynx <zlynx@acm.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: echo mem > /sys/power/state
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org>	<1200591411.34145.4.camel@localhost> <20080117111355.29554f38.akpm@linux-foundation.org>
In-Reply-To: <20080117111355.29554f38.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2008 08:13 PM, Andrew Morton wrote:
> On Thu, 17 Jan 2008 10:36:51 -0700 Zan Lynx <zlynx@acm.org> wrote:
>> Heh.  Laptop suspend to anything has been so broken for so long in the
>> -mm series on my Compaq R3000 that I didn't even know it was ever
>> supposed to work.
> 
> It gets broken more often than anything else.  I do test each release on
> two laptops and I get to do a lot of bisection searching and
> grumpygramming as a result.
> 
> Probably it would be more efficient to have the people who wrote the code
> also test it.

Big fat ACK from here. Suspend issues in past few -mms were *very* hard (and 
time consuming) to track down.

Looking forward to test suspend of -rc8-mm1 :),
--js
