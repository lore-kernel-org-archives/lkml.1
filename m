Return-Path: <linux-kernel-owner+w=401wt.eu-S1751403AbZGaOXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbZGaOXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 10:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZGaOXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:23:09 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:57050 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZGaOXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:23:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JOhElMbQZJo17kOxPdtOWMCgHczNxvib36knz5ZFZKDrfDBTGP5AJuRA5d5aBQlUar
         BzuDlpZieFZHb5zxQIe+mLrUjOwdoDqeI+ic/mhkDY9EXmoh+wf06bfQPs5MgVlMeGDt
         RvKDB6XtXtAsIxLSpuTEx1Bvj1PsXQI4Pkl0A=
MIME-Version: 1.0
In-Reply-To: <20090731121811.GA3989@elte.hu>
References: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
	 <1245352632.7508.1.camel@localhost.localdomain>
	 <aec7e5c30906252230s62196e1fr5671aa591f1869a3@mail.gmail.com>
	 <20090731121811.GA3989@elte.hu>
Date: Fri, 31 Jul 2009 23:23:08 +0900
Message-ID: <aec7e5c30907310723h4a99231ds6eed8c646993cce0@mail.gmail.com>
Subject: Re: [PATCH] clocksource: save mult_orig in clocksource_disable()
From: Magnus Damm <magnus.damm@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, tglx@linutronix.de, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 9:18 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> On Fri, Jun 19, 2009 at 4:17 AM, john stultz<johnstul@us.ibm.com> wrote:
>> > On Fri, 2009-06-19 at 00:24 +0900, Magnus Damm wrote:
>> >> From: Magnus Damm <damm@igel.co.jp>
>> >>
>> >> Save clocksource mult_orig in clocksource_disable().
>> >>
>> >> To fix the common case where ->enable() does not setup
>> >> mult, make sure mult_orig is saved in mult on disable.
>> >>
>> >> Also add comments to explain why we do this.
>> >>
>> >> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>> >
>> > Acked-by: John Stultz <johnstul@us.ibm.com>
>> >
>> > Thomas, Andrew, please push this for 2.6.31.
>>
>> This one is slowly making it's way in I suppose?
>
> Btw., what specific issue does this fix? The commit description is
> generic, there's no bugzilla link and no other information either
> that could give me an idea about precisely what incarnation of the
> bug you have hit.

The comments in the actual code gives more details, but that's
probably not where you want this to be explained. I can resend a
version with more verbose commit message early next week if you'd
like. Please let me know if so.

I'm not aware of any bugzilla links, maybe John knows?

Cheers,

/ magnus
