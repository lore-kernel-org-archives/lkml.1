Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZJLKNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZJLKNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZJLKNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:13:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:11801 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZJLKNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:13:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IPwzsGWV7G7vchNdww8Tn8hcJEKV7YvaNb5dWl40q2CwHgOnYn0+jlBB8opE0QIvjx
         m6eIXHCy3f4cw0HrUtRirywOt2mj8jilprX8z80qMeu39TprWJqKr+AcA7BvT4YKjEmr
         qrVr4pnrskXu8UAMSToFPAxHZZzNg4/8f0ChA=
Message-ID: <4AD300C8.3090502@gmail.com>
Date: Mon, 12 Oct 2009 12:11:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.8 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Stanse 1.0.0 released [was: wireless: wl12xx, fix lock imbalance]
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com> <1247521235.7178.1.camel@johannes.local> <4A5BAABF.9020708@gmail.com> <1247521789.7178.2.camel@johannes.local> <4A5BAC77.9010503@gmail.com> <1247522068.7178.4.camel@johannes.local> <20090718111948.GD27287@elte.hu> <1247916829.1055.24.camel@johannes.local> <20090718161029.GA16343@elte.hu>
In-Reply-To: <20090718161029.GA16343@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2009 06:10 PM, Ingo Molnar wrote:
>>> Plus static tools like Jiri is working on are very useful as 
>>> well. I think Coverty does that too and it's a pity we dont have 
>>> free tools for that. In fact Covery will sweep clean the kernel 
>>> of such bugs, giving OSS tools like 'stanse' the false 
>>> impression that there are no such bugs. There are such bugs - 
>>> there's a constant influx of them. So please work on this, it 
>>> looks very useful.
>>
>> What's "this" in this context?
> 
> this == stanse, the static code analyzing thing Jiri mentioned he is 
> working on. The webpage says it will be under the GPL - that's good. 
> Jiri, any release date for the source code?

Hi all. I'm pleased to announce the first official Stanse release.

For those who are interested, the tool (with other information and
documentation) is available at
http://stanse.fi.muni.cz/

There are also prebuilt rpm packages for openSUSE and Fedora 11. (Some
of them still building, will be available soon. Sorry for that, build
service is slow as hell these days.)

Also I pre-ran the stanse on 2.6.32-rc3 with results available online.
The webpage concerning this is at:
http://decibel.fi.muni.cz/~xslaby/stanse/?db=32-rc

So for those who are not interested in the toolkit itself but only in
results from more-or-less latest kernel may try it that way.

There are many janitor-like bugs. E.g. not testing return values from
k*alloc might be seamlessly taken care of by janitors, I think.

As it's only static analysis not based on symbolic execution (we will
play with that later), there are some/many (depending on a checker) many
false positives. There is a mechanism for marking them. I ask everybody
who finds a FP or error to mark the entry as such.

I'm still trying to lower FP rate. If somebody finds out another method
to do so, please share with us.

Any input appreciated. Hope it helps.

Thanks to those who support us,
--js
