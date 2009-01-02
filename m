Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbZABF7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbZABF7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 00:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbZABF7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 00:59:14 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:38613 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZABF7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 00:59:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OKKSN309eOrgKj7nDUmb8HoXuPSv35Ibt/8DAlyp1ExqwQNMnI+V3mHq38OjdmMw3H
         DlfOKOFDV98p/MNs7txvrIgdcP33DPHlIurnnpXT3NVxqtuaOlp3AynO83tJnIA3pW9p
         yI6EuEARQA7zWZR42BRuzVMLbmV1td8ucXQ1k=
Message-ID: <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com>
Date: Fri, 2 Jan 2009 11:29:12 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Bryan Donlan" <bdonlan@gmail.com>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
Cc: "Ingo Brueckl" <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495d2974@wupperonline.de>
	 <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 10:49 AM, Bryan Donlan <bdonlan@gmail.com> wrote:
> On Thu, Jan 1, 2009 at 3:37 PM, Ingo Brueckl <ib@wupperonline.de> wrote:
>> Is there any reason why CONFIG_PROCESSOR_SELECT is limited to EMBEDDED only?
>>
>> In my desktop pc is one specific cpu only, so I do not need support for the
>> other processors. Unfortunately, I have no chance to disable the other ones.
>>
>> As it is already configurable, why not giving this option to everyone?
>
> EMBEDDED is just a switch to enable configuration options related to
> removing 'core' features of the kernel to save space. Think of it as a
> safety to avoid accidentally turning off something important. Feel
> free to switch on EMBEDDED if you want to use CONFIG_PROCESSOR_SELECT
> - just enabling EMBEDDED doesn't do anything by itself.

I think EMBEDDED is a misnomer for using CONFIG_PROCESSOR_SELECT and
should be used for more specific to Embedded stuff like for Embedded
range of CPUs or Embedded Systems.

Thank you,
JSR.
