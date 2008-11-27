Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbYK0Ttg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbYK0Ttg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 14:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbYK0Tt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 14:49:27 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:51058 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYK0Tt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 14:49:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=MkZ2kdkOsIfXJ8b4FKTC7P4H8dse0RuxPFvIiHSzFKoroUiqpvf+NFB1x6octq3p45
         7l1hvCPB1oNpshDrI8SsFzm4NyuWuDNgOlxuuCRM7KBoYUQ8aMo5/9upEZynD6T+9rrU
         Txyp0TPWc0hil6csvD/bFCkmlDwVYuzwcU1AQ=
Message-ID: <7c86c4470811271149m5f5556c0y468be509bb6a200@mail.gmail.com>
Date: Thu, 27 Nov 2008 20:49:25 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 02/24] perfmon: base code
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
In-Reply-To: <alpine.LFD.2.00.0811272031540.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>
	 <alpine.LFD.2.00.0811271638350.3325@localhost.localdomain>
	 <7c86c4470811270947q585cba5vf8bdb875962a1856@mail.gmail.com>
	 <alpine.LFD.2.00.0811271858300.3325@localhost.localdomain>
	 <7c86c4470811271051g66669197qb6b5fd39961668a9@mail.gmail.com>
	 <alpine.LFD.2.00.0811272031540.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 8:35 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Stephane,
>
> On Thu, 27 Nov 2008, stephane eranian wrote:
>
>> >> session is independent of each other. You can therefore measure different
>> >> things on different CPUs. Reservation is thus done independently for each
>> >> CPU, therefore we need a cpu bitmask  to track allocation.
>> >
>> > Ok. Question: if you do a one CPU wide session with perfom, can you
>> > still do thread monitoring on the same CPU ?
>> >
>> No. They are currently mutually exclusive.
>>
>> > If no, what prevents that a monitored thread is migrated to such a CPU ?
>> >
>> Nothing. AND you don't want to change affinity because you are monitoring.
>> So the current restriction is that cpu-wide and per-thread are
>> mutually exclusive.
>
> And how is this achieved ? Currently there seems nothing which
> prevents a per-thread vs. cpu-wide monitoring.
>
That's true, but that's because cpu-wide support is not included in the
patchset.
