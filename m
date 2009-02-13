Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbZBMQth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbZBMQth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZBMQt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:49:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:17467 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZBMQt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:49:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TQw/2TsqUTPc3/rJvCCIoVb8x+3jkyV3AHPKub+0dX0szbNc//ZXLpLEGv0+OhBaS1
         YN3By0Sn+sx4BaNtklZjuPquVirW2ruhzQTZfxsRb1vgIhiCO45FZSTIudoSVyB8hJW6
         pifizi2HwC1T7V4tIouqLx+kgrglKRsGfF9QE=
MIME-Version: 1.0
In-Reply-To: <4995A20A.2060802@oracle.com>
References: <20090212194408.ff7489c1.sfr@canb.auug.org.au>
	 <49946DB8.9030801@oracle.com> <20090213082556.GB4606@elte.hu>
	 <4995A20A.2060802@oracle.com>
Date: Fri, 13 Feb 2009 22:19:26 +0530
Message-ID: <3f9a31f40902130849k7d9efb50v48a600aa16f41811@mail.gmail.com>
Subject: Re: [PATCH -next] x86_32: fix printk formats
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 10:08 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Ingo Molnar wrote:
>> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> Fix printk format warnings and also change 2 %ld to %lu for unsigned long
>>> variables.
>>>
>>> arch/x86/mm/init_32.c:727: warning: format '%u' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
>>> arch/x86/mm/init_32.c:735: warning: format '%u' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
>>>
>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>> ---
>>>  arch/x86/mm/init_32.c |    8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> Already fixed in the x86 tree, but thanks.
>
> OK, but this still shows up in linux-next of 20090213.
> Did the fix just miss the today's pull or is there a git #branch issue
> or what?
>

Ahh, because I fixed for :
 arch/x86/mm/init_32.c:696: warning: format '%u' expects type
'unsigned int', but

This part was remaining.

Thanks Randy,
--
JSR
