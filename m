Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZC0KKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZC0KKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZC0KKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:10:44 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:47852 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZC0KKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S9fGfcEcFM3nsjMWeyEksI3XmLNuuEr7eZRa533BNF2eKOg9pOkvm7lX5BfEUewKeP
         s8HoqmB5G3uFdt3m2GHpCR5e12mNzGO6MHcN3JB/kOesjGUgj6Wee6fT4U2N95/Tu7In
         H9NHDqXQqh6pD4A3uWxjQJe67ZzHBHTxXr330=
MIME-Version: 1.0
In-Reply-To: <4e5e476b0903261454h1525c30chdc86dbcb1cf3cb5c@mail.gmail.com>
References: <4e5e476b0903260847m1de3e976ne20279df359176cf@mail.gmail.com>
	 <9b2b86520903260958r790e5459r553308311522e88f@mail.gmail.com>
	 <4e5e476b0903261454h1525c30chdc86dbcb1cf3cb5c@mail.gmail.com>
Date: Fri, 27 Mar 2009 10:10:39 +0000
Message-ID: <9b2b86520903270310x78193514l44b89ed6d3088cf8@mail.gmail.com>
Subject: Re: "ACPI: EC: missing confirmations, switch off interrupt mode" 
	wastes time on startup
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/09, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> On Thu, Mar 26, 2009 at 5:58 PM, Alan Jenkins
> <sourcejedi.lkml@googlemail.com> wrote:
>> On 3/26/09, Corrado Zoccolo <czoccolo@gmail.com> wrote:
>>
>> Currently there is no option to force polling, sorry.  I'm _guessing_
>> this was a deliberate omission.  But I can sympathise that even 0.5s
>> boot delay is bad on a netbook.
>>
> Yes. Do you think that changing olpc_ec_timeout kernel parameter may
> help in getting the timeout sooner?
>

No, that's something different.  There's no boot option to change the timeout.

>> Feel free to create a new bugzilla entry.  You can attach the full
>> output of dmesg, but acpidump is probably not required.  What would be
>> really helpful is if you could file on bugzilla, and attach a full
>> debug trace.  I.e. as well as the normal dmesg, attach the dmesg
>> output after recompiling with this change:
>>
>
> bug: http://bugzilla.kernel.org/show_bug.cgi?id=12949
> full debug dmesg: http://bugzilla.kernel.org/attachment.cgi?id=20695

Great.
