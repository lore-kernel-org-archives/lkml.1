Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbZINM6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbZINM6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZINM6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:58:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:11601 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZINM6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v6DL66gIykTQZlhiBMzH7Nx3XcPkkeZd4jSFKp47TiWUjCGcvwMHGlH7rbksr1WG/E
         8HrlCOYjmaCmovQqFKJm/ebPYhw9ZoKeK6qQhNcWTWpwhr/0RSOz8n8L26zqfkeAYITv
         oQMaOn0qb8EaIIMT1LmpbaWe+X/xZuwfQGB/w=
MIME-Version: 1.0
In-Reply-To: <20090914081001.GB14519@n2100.arm.linux.org.uk>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
	 <200909132328.47079.marek.vasut@gmail.com>
	 <20090913230008.GC30169@n2100.arm.linux.org.uk>
	 <20090914002100.GD30621@shareable.org>
	 <20090914081001.GB14519@n2100.arm.linux.org.uk>
Date: Mon, 14 Sep 2009 15:58:24 +0300
Message-ID: <94a0d4530909140558nd8d2c47lc9954563c80a574f@mail.gmail.com>
Subject: Re: [PATCH] arm: remove unused code in delay.S
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>, Marek Vasut <marek.vasut@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 11:10 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Sep 14, 2009 at 01:21:00AM +0100, Jamie Lokier wrote:
>> Russell King - ARM Linux wrote:
>> > On Sun, Sep 13, 2009 at 11:28:47PM +0200, Marek Vasut wrote:
>> > > >                 bhi     __delay
>> > > >                 mov     pc, lr
>> > > >  ENDPROC(__udelay)
>> > > >
>> > > Hi
>> > >
>> > > why was this code there in the first place ?
>> >
>> > To make the delay loop more stable and predictable on older CPUs.
>>
>> So why has it been commented out, if it's needed for that?
>
> We moved on and it penalises later CPUs, leading to udelay providing
> shorter delays than requested.
>
> So the choice was either stable and predictable on older CPUs but
> buggy on newer CPUs, or correct on all CPUs but gives unnecessarily
> longer delays on older CPUs.

Why not add an #ifdef CPU_V4 or whatever?

-- 
Felipe Contreras
