Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbZJCWzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbZJCWzD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 18:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZJCWzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 18:55:02 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:40698 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbZJCWzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 18:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=LncuscPl6/ZvXUdH6g36zA7K6dojME6T3suviVjvVkJPyDqfKV1ETnqKnPzrpU/6JS
         239jKgXRBj+RVcd1iReLhFVc2WH4kbUu0h1dPRcRKXRh6VmW2IaakUzSWAjEffDgG1sv
         gdnifrK5WW+LJPP8jvbzNXafk6mS9bhhg0KNg=
MIME-Version: 1.0
In-Reply-To: <20091003223210.GA4193@boogie.lpds.sztaki.hu>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 
	<20091003110546.78958508@infradead.org> <40101cc30910031504pa9f8536k82dbd7668dfa643d@mail.gmail.com> 
	<20091003223210.GA4193@boogie.lpds.sztaki.hu>
From: Matteo Croce <technoboy85@gmail.com>
Date: Sun, 4 Oct 2009 00:54:03 +0200
Message-ID: <40101cc30910031554w40a0f93ata5decac55cbcba5c@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 12:32 AM, Gabor Gombas <gombasg@sztaki.hu> wrote:
> On Sun, Oct 04, 2009 at 12:04:03AM +0200, Matteo Croce wrote:
>
>> yes cmov and i686 are unrelated but some distros (Debian & co.)
>> compiles libraries for two archs:
>> i486 and i686-cmov so only i686 machines does benefit from cmov.
>> This is why I cared about having an i686 aware userspace but it seems
>> that for a missing instruction I can't do that
>
> You could emulate the missing instruction. As long as it is not really
> used, the performance cost of the emulation should not matter. Of course
> if userspace starts to use long NOPs extensively then it becomes a
> problem.

Emulate? I can replace it with two plain NOPs.
How can I do the "emulation"? trapping SIGILL?
