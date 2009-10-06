Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbZJFQK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbZJFQK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbZJFQK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:10:58 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:50406 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957AbZJFQK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dutnD+O+OyRJtAPfsqOa/utH8AIos0S+vpYuSVETMIRFR2cqmNIYQsLNgZVS6CNbpm
         TB09NO/Fa7Mq+yzvADlo/b5dx5/wR1QjMZvrwatIO9/AFU+p7chc2WdFUPZDVGo1ytgJ
         XiykWkum3vjgMrxo+hp8YB5RI7jR2YN3oLgsA=
MIME-Version: 1.0
In-Reply-To: <4ACB653B.9090707@msgid.tls.msk.ru>
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
	 <68676e00909200520s7730b516v4e0d6c17d529d0a7@mail.gmail.com>
	 <4AC939BB.8090600@wasp.net.au>
	 <68676e00910050837g2006bfb8j349891504e474a95@mail.gmail.com>
	 <4ACA21E8.6080501@msgid.tls.msk.ru>
	 <68676e00910060800h4cb84dcl9f610f6b23a88e5c@mail.gmail.com>
	 <4ACB60A7.307@msgid.tls.msk.ru>
	 <68676e00910060834p338c77c8kae8156a1f8dc68a9@mail.gmail.com>
	 <4ACB653B.9090707@msgid.tls.msk.ru>
Date: Tue, 6 Oct 2009 18:10:20 +0200
Message-ID: <68676e00910060910m7744a6dcua2a344ce44b9de6e@mail.gmail.com>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
From: Luca Tettamanti <kronos.it@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Brad Campbell <brad@wasp.net.au>, lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 5:41 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Luca Tettamanti wrote:
>>
>> On Tue, Oct 6, 2009 at 5:22 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>>> Ok.  Now a pure technical question, finally.  Is there a
>>> way to made asus_atk0110 to be able to *set* fan speeds
>>> too, in a way as it's done by it87?
>>
>> In term of Q-FAN profiles: yes, but I still haven't managed to make it
>> work (the interface is there though).
>
> Oh, so it's basically boils down to Silent/Optimal/Normal choices
> as in the BIOS settings, right?  I mean, still no pwm_* controls
> as it87 offers?..

It's motherboard specific. On some model with w83627ehf it's possible
to activate thermal cruise control (with a given target temperature).
I've never seen direct pwm or dc control; it's theoretically doable
with a custom DSDT ;-)

Luca
