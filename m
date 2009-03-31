Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbZCaGGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbZCaGGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbZCaGGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:06:35 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:37618 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbZCaGGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:06:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vjHSfeSEsfkT4M5LESwsL+05vvVjliD6CigkIyFhNNZEigdyHahfpXCF26F5vt5/5N
         DGfY4htXllNZxdxvMBsGiJDsUWSATr+izswstovnhxK3hEWKqUKlKfUFdc8nLLAy1TI/
         qWvGeoKcDrLMXn6SfFt296lzO3spJJGbdadNM=
MIME-Version: 1.0
In-Reply-To: <20090329095917.20948680@infradead.org>
References: <4e5e476b0903290840o453bcccdm5800a636078fde6e@mail.gmail.com>
	 <20090329085119.0c93fb21@infradead.org>
	 <4e5e476b0903290945u19572af6ub366001596a7fd3f@mail.gmail.com>
	 <20090329095917.20948680@infradead.org>
Date: Tue, 31 Mar 2009 08:06:31 +0200
Message-ID: <4e5e476b0903302306n13b84090j2006e89c16735359@mail.gmail.com>
Subject: Re: How to debug kernel startup time?
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 6:59 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sun, 29 Mar 2009 18:45:36 +0200
> Corrado Zoccolo <czoccolo@gmail.com> wrote:
>
>> On Sun, Mar 29, 2009 at 5:51 PM, Arjan van de Ven
>> <arjan@infradead.org> wrote:
>> > On Sun, 29 Mar 2009 17:40:10 +0200
>> > Corrado Zoccolo <czoccolo@gmail.com> wrote:
>> >
>> >> Hi,
>> >> I'm seeing around 2 s "lost" during kernel boot, that are not
>> >> accounted for any init call (excerpt of dmesg with initcall_debug
>> >> follows, kernel is 2.6.29).
>> >> What's the suggested way to investigate such problems?
>> >
>> > I take it you don't have an initrd ?
>>
>> You guessed right.
>>
>> >
>> > If so I know what you are hitting; I have a patch to solve it but
>> > it's a bit convoluted and not ready for mainline.... let me know if
>> > you want to try it, I suspect it'll solve your issue ;)
>> >
>>
>> Sure. I'd like to test it.
>>
>
> attached...

They worked fine. With fastboot enabled + some ACPI patch that alexei
is working on, I can now boot the kernel in 1.7s.

Corrado

>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
