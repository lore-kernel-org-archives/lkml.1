Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbZKHQz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbZKHQz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZKHQz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:55:28 -0500
Received: from borg.medozas.de ([188.40.89.202]:43761 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbZKHQz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:55:28 -0500
Date: Sun, 8 Nov 2009 17:55:32 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH v4 00/12] introduce skip_spaces(), reducing 
 code size plus some clean-ups
In-Reply-To: <b8bf37780911080852l10d11f4ele5bf6a6aed94c5fe@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0911081754360.30674@obet.zrqbmnf.qr>
References: <cover.1257602781.git.andre.goddard@gmail.com>  <1257696303.4184.8.camel@mulgrave.site> <b8bf37780911080852l10d11f4ele5bf6a6aed94c5fe@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 2009-11-08 17:52, André Goddard Rosa wrote:

>Hi, James!
>
>On Sun, Nov 8, 2009 at 2:05 PM, James Bottomley
><James.Bottomley@hansenpartnership.com> wrote:
>> Before we embark on something as massive as this, could we take a step
>> back.  I agree that if I were coming up with the strstip() interface
>> today I probably wouldn't have given it two overloaded uses.
>>
>> However, I think the function, in spite of this minor issue, is very
>> usable.  I still don't understand why people thought adding a
>> __must_check, which is what damaged one of the overloaded uses, is a
>> good idea.
>
>Differently of "static void strip(char *str)"@scripts/kconfig/conf.c ,
>this function
>does not moves the characters to the beginning of the string, so that if that
>string is going to be reused it should refer to the newly returned string start.
>
>I've changed it to remove the const and return a "char *".
>
>Do you think __must_check is not needed as well?

If you called strstrip, and not use its result, what good would that
do besides being effectively a strrtrim? __must_check is a good thing IMO.
