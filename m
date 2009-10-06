Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZJFPWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZJFPWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZJFPWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:22:54 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:45395 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbZJFPWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:22:54 -0400
Message-ID: <4ACB60A7.307@msgid.tls.msk.ru>
Date: Tue, 06 Oct 2009 19:22:15 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Brad Campbell <brad@wasp.net.au>, lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>	 <68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>	 <4AC939BB.8090600@wasp.net.au>	 <68676e00910050837g2006bfb8j349891504e474a95@mail.gmail.com>	 <4ACA21E8.6080501@msgid.tls.msk.ru> <68676e00910060800h4cb84dcl9f610f6b23a88e5c@mail.gmail.com>
In-Reply-To: <68676e00910060800h4cb84dcl9f610f6b23a88e5c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Tettamanti wrote:
> On Mon, Oct 5, 2009 at 6:42 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
[]
>> Well, I just tried it here and it works here too, on 3 different
>> asus motherboards.  But asus_atk0110 is far less useful than the
>> it87 variant.  Yes atk0110 shows correct labels for various sensors,
>> but for one there's no way to control fan speeds using it, at least
>> not currently, -- something which is done by it87 easily.
[]
> The main reason for using atk0110 is correctness: the resources are
> claimed by ACPI, it might not be safe to touch them (for the same
> reason two drivers are not allowed to map e.g. the same PCI BAR).
> On newer boards the risk of collision is pretty high, since the hwmon
> chip is used by an EC that works in background... on other boards the
> risk is much lower since the hwmon chip doesn't seem to be probed
> actively.
> Anyway, as user you can override this decision with
> "acpi_enforce_resources=lax", but _I_ wouldn't recommend it.

If there's a choice between "does not work but correct" and
"incorrect but works", i'd prefer the latter, and I'd say any
sane person agrees.

I spent quite some time choosing a motherboard that is able
to control fan speeds.  Now if know that it does that "incorrectly".
So I should either throw it away because one of the most
important criterias (ability to control noise level) does
not satisfy me anymore, or use it the "wrong" way as I did
for whole last year.  Ditto for 4 other asus motherboards
that have exactly the same problem.

Yes I know about acpi_enforce_resources.

Ok.  Now a pure technical question, finally.  Is there a
way to made asus_atk0110 to be able to *set* fan speeds
too, in a way as it's done by it87?

Because that's mostly the only issue with this driver,
and for me at least it's a show-stopper.

Thanks!

/mjt
