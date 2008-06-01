Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYFAT7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYFAT7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 15:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYFAT7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 15:59:09 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:47406 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYFAT7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 15:59:09 -0400
Date: Sun, 01 Jun 2008 21:59:07 +0200
Message-Id: <300254332@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug 10797] Something is consuming power after shutdown
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19a05/2GiIUFKy2YdVSDjNT7vYQ9WkhPkBikXmTXidOET/6y
 dv1gJU2cVvMRisx4/gHhIQoD0mOsfIo04CTLdh4JtNgUJ8xUI8=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Renato S. Yamane wrote:
>> ...
>>> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
>>> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=481493>
>>
>> Try to find out which component eats power, eg. by opening the machine
>> searching for heat.
>> 
>> (And yes, your hw is broken; on pc it is traditionaly hw
>> responsibility to power machine down.)
>
>OK, I try do this but I think this is very difficult because demand
>power is very low and is not enought to do hot some component. But I
>will try.

i also don`t think that you can find something which is noticeably warm this way - 4% of your battery in 12hrs - that "hot spot" should be hard to identify - and opening notebooks for getting access to the all parts of the mainboard may be hard/dangerous.

>I don't think that my hardware is broked because I don't have this kind
>of problem on Kernel <=2.6.22 or in other OS.
>
>And other user have the same problem (cc'ed on Bug #10797)

if your notebook powers down and doesn`t show that something is still "on" and consuming power - i`d call that "broken by design".
it should not be up to the operating system to make sure that all parts of the hardware are switched to off.

if i power down some device and there is nothing showing "hey, here is something active" (e.g. by some led or lcd) - i expect it to stop consuming power. 

maybe it`s not that broken as my PC, which is consuming 20W after power-off  (due to power-supply) - but i really would go ask the vendor and first complain there.

they should know the details.
_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

