Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbZKXCBC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbZKXCBC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 21:01:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZKXCBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 21:01:01 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:37664 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZKXCBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 21:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gB6xdypP7RN4ttfw+7TnVzoY1ckyGvYf7zi5BViG1d96YZPM5YRy2nXBjAPcNpgqKJ
         ouBadC34EJoq80+yIMgF/gvYqYaxgTJu6keXzlzfOAlyhqrVKhd4uSuNYSlleztzR1Dx
         g7q2cu1IXei3r4ykUws+XLl4rlhLbKLO/Ie5g=
Message-ID: <4B0B3E5F.4060102@gmail.com>
Date: Mon, 23 Nov 2009 20:01:03 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mike Smith <scgtrp@gmail.com>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Toshiba Satellite ACPI problems
References: <525c5a6c0911231620u6d23810fu9fed3605617fe421@mail.gmail.com> <200911240137.39266.rjw@sisk.pl>
In-Reply-To: <200911240137.39266.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 06:37 PM, Rafael J. Wysocki wrote:
> [Adding linux-acpi to the CC list.]
>
> On Tuesday 24 November 2009, Mike Smith wrote:
>> I have a brand new Satellite L505D-S5983 which I'm trying to install
>> Linux on. Whenever I boot a Linux kernel on it with no special
>> parameters it enters an in(de)finite loop dumping messages like this:
>>
>> ACPI Error (uteval-0313): Return object type is incorrect
>> [\_SB_.HSB1._STA] (Node ffff8800af8121a0), AE_TYPE
>> ACPI Error: Type returned from _STA was incorrect: Device, expected
>> Btypes: 1 20090521 uteval-319
>> ACPI Error (psargs-0359): [DR ] Namespace lookup failure, AE_NOT_FOUND
>> ACPI Error (psparse-0537): Method parse/execution failed
>> [\_SB_.VALZ._STA] (Node ffff8800af812540), AE_NOT_FOUND
>> ACPI Error: Found unknown opcode 39 at AML address ffffc900000132cd
>> offset 0, ignoring 20090521 psloop-137
>> [...]

Hmm, that looks really unhappy..

>>
>> If I boot with acpi=noirq these messages only continue for a few
>> seconds, although they cause a couple of initscripts to hang later on.
>> With ACPI fully enabled they keep appearing forever and the system
>> doesn't finish booting. With acpi=off they don't appear at all (but
>> the fan stays at low speed and the laptop gets quite hot if run for
>> more than a few minutes).
>>
>> I've found only one other mention of this problem on the internet
>> (http://ubuntuforums.org/showthread.php?p=8358864#post8358864) from
>> someone with the same laptop as mine, but there was no working fix
>> posted to that thread beyond completely disabling ACPI. More research
>> told me that there used to be a way of fixing up the DSDT and having
>> it loaded from the initrd but the new policy is to just ask the
>> manufacturer to fix it and the kernel developers to work around it,
>> so... here it is. (Angry emails to Toshiba and Best Buy pending.)
>>
>> Full dmesg output can be found at http://slexy.org/view/s25zU08AKJ
>> (By the way, what's the correct way to include dmesg output in a lkml
>> message if you don't know for sure which parts are relevant? Dumping
>> all 50k or so of it into the email seems like the wrong thing to
>> do...)
>
> I think it's better if you file a bug report against ACPI at bugzilla.kernel.org.

Can you extract and post the DSDT in either raw or decompiled form, as 
described here:

http://smackerelofopinion.blogspot.com/2009/10/dumping-acpi-tables-using-acpidump-and.html
