Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZEHGSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZEHGSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 02:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZEHGSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 02:18:43 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:65525 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbZEHGSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 02:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZoyyCe+TzOY+KaVlfHXl7sSfFqivdxZscwbW2cVLzz0vjqmafFKrZowM8BPBZILYLF
         F0RdN20S+Z1z0vNTdOlxxqVlkj6MdUV8+fx2u34z00oOql0QKvZC60XHHAwS6FmTGgIN
         CWk+Rfy19lI8FOOkFDd1GpxcRKSaLzx+fx4TA=
MIME-Version: 1.0
In-Reply-To: <4A03C4B6.5070308@goop.org>
References: <3e8340490905072118s6d7a4127tff932317213febb4@mail.gmail.com>
	 <4A03C4B6.5070308@goop.org>
Date: Fri, 8 May 2009 02:18:41 -0400
Message-ID: <3e8340490905072318v7a695863nd3c43bb1587da1cc@mail.gmail.com>
Subject: Re: [BISECTED REGRESSION] Xen: OOPSes on heavy block IO on 
	2.6.30-master
From: Bryan Donlan <bdonlan@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 8, 2009 at 1:35 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Bryan Donlan wrote:
>>
>> I've bisected this problem down to the following commit;
>> unfortunately, there were some rather hairy interdependencies after
>> that point, so I wasn't able to test reverting it on top of master:
>> commit 93dbda7cbcd70a0bd1a99f39f44a9ccde8ab9040
>> Author: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> Date:   Thu Feb 26 17:35:44 2009 -0800
>>
>
> Thanks for going to the trouble of bisecting this, but I'd just fixed this
> bug :/
>
> The patch below should fix it.
>
> Thanks again,

Seems to work, thanks.

Bryan Donlan
