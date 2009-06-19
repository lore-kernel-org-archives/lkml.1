Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbZFSScl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbZFSScl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZFSSce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:32:34 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:58591 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZFSScd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QSXUJxw25fgyG3wlsw/cOLDhY72qr77ukNxN7w70kIeSX4DfoN2Vs4ebe0NN6PU3Cg
         MyrXJrnLM+x4ZZfvlWWzOhKDciFb3V4YRw+s16YAfY5/K/0Ai2cAOqeMVSRMRWXVtYNJ
         RlGyyqpB45eJ6PyDY5chd3mCOtMwxu+o7Wf0c=
MIME-Version: 1.0
In-Reply-To: <200906191307.45135.rgetz@blackfin.uclinux.org>
References: <8bd0f97a0906180824y17a00110i57565aee16207e5@mail.gmail.com> 
	<200906190854.13052.rgetz@blackfin.uclinux.org> <8bd0f97a0906190614x2ed27fcdrb59ea339eb45ba82@mail.gmail.com> 
	<200906191307.45135.rgetz@blackfin.uclinux.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 19 Jun 2009 14:32:15 -0400
Message-ID: <8bd0f97a0906191132n42eda4e3n680503c56f22640a@mail.gmail.com>
Subject: Re: module version magic and arches with symbol prefixes
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 13:07, Robin Getz wrote:
> On Fri 19 Jun 2009 09:14, Mike Frysinger pondered:
>> On Fri, Jun 19, 2009 at 08:54, Robin Getz wrote:
>> > On Fri 19 Jun 2009 01:38, Rusty Russell pondered:
>> >> No, it means the kernel didn't build properly.
>> >
>> > Or a module didn't build properly.
>>
>> nah, when i talked to you earlier i was wrong -- this find_symbol() is
>> looking up the symbol in the kernel, not in the module.  the lookup of
>> the symbol in the requested module actually works.
>
> Wouldn't it make sense to move this somewhere else then? and add a
> __initcall() for it? We should only need to check for it once - it would make
> things insignificantly faster, and smaller :)

it would also have the advantage of the BUG() being noticed sooner ...
but up to Rusty i guess.
-mike
