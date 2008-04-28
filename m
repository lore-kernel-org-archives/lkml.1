Return-Path: <linux-kernel-owner+w=401wt.eu-S934966AbYD1OYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934966AbYD1OYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934211AbYD1OY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:24:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:29467 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933797AbYD1OYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=HeYJCjdK63HfUJSjmVLvbvHosjXU9IgEeziCYrZwfnnjavoLqLw+XTRNiTLZZ5JzayI431BL9xbzJN5BkNQ8xjRhP9PDAYg/IbG00COJF9A+UKp5NACpFU+WPzOWu2BGYKWSKsSDoRfo80tIjzy8trK2bO8gdX3yriv3KEbaqws=
Message-ID: <4815DE0C.6000802@googlemail.com>
Date: Mon, 28 Apr 2008 16:24:12 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Mika Fischer <mika.fischer@zoopnet.de>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com> <200801202256.48365.yinghai.lu@sun.com> <20080122165125.GA17992@elte.hu> <200801221623.20861.yinghai.lu@sun.com> <20080426035614.a30afb17.akpm@linux-foundation.org> <48132665.8050202@googlemail.com> <86802c440804272344yac6a9f0n40809169424247e6@mail.gmail.com> <48159668.5010808@googlemail.com> <86802c440804280234y5b38b4bds330fc1a6987202c5@mail.gmail.com> <48159ECF.9020004@googlemail.com> <20080428135351.GF3973@elte.hu> <4815DB15.4070908@zoopnet.de>
In-Reply-To: <4815DB15.4070908@zoopnet.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mika Fischer wrote:
> Hi Ingo,
> 
> I'm having the same problem.
> 
> Ingo Molnar schrieb:
>> excellent. So just to make sure: this box never had proper graphics 
>> under Linux (under no previous kernel), due to the way the BIOS has set 
>> up the MTRR's, right?
> 
> Well, not quite. X still works fine, but since the video memory is
> overlapped by two of the existing MTRRs, X cannot add a write-combining
> range for the video memory. That makes X rather slow especially if you
> use DRI for Compiz etc.

Well you are lucky then :) 

Yeah X 'worked' but it worked as slow as with vesa video driver here.

Also starting something like supertuxkart made it crash or I got a black screen :(

The only game I managed to start ( without X to crash ) without that patch was supertux but is was slow as hell.
However I'm not a gamer but I need X to work right.


> Regards,
>  Mika
> 


Gabriel
