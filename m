Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbZKHQ7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbZKHQ7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbZKHQ7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:59:23 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:60838 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbZKHQ7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:59:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hxOgOrDVBRV1BxRnx3H97+IPWhSV9ibXB8M1hl+3hfQEsZXxWDsOMBP7uQGHO8v3l8
         LEvVP17wNu1hxUxBz+NP2o80Z+vQXwaphtXHxoztEJ4pdTg3A3UM152Wa+vebZjOOi9w
         66qPzQoakRicbleOLunBDxk0GA0MKUlGTT8Sg=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0911081753210.30674@obet.zrqbmnf.qr>
References: <cover.1257602781.git.andre.goddard@gmail.com> 
	<c7d3b02b5e28eaa54a5360d57dfd177c44320187.1257602781.git.andre.goddard@gmail.com> 
	<1257698285.4184.10.camel@mulgrave.site> <alpine.LSU.2.00.0911081753210.30674@obet.zrqbmnf.qr>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 8 Nov 2009 14:59:08 -0200
Message-ID: <b8bf37780911080859s26c41dfw5a908874e41e1d9b@mail.gmail.com>
Subject: Re: [PATCH v4 10/12] string: factorize skip_spaces and export it to 
	be generally available
To: Jan Engelhardt <jengelh@medozas.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 2:54 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Sunday 2009-11-08 17:38, James Bottomley wrote:
>
>>On Sat, 2009-11-07 at 14:23 -0200, André Goddard Rosa wrote:
>>> + * skip_spaces - Removes leading whitespace from @s.
>>> + * @s: The string to be stripped.
>>> + *
>>> + * Returns a pointer to the first non-whitespace character in @s.
>>> + */
>>> +char *skip_spaces(const char *str)
>>
>>OK, so this now becomes a bad interface because it silently promotes
>>const to non const ...
>
> strchr, etc. all do the same. Do you think they are bad too?

Yeap, I just based on those.

James, what would you suggest instead?

Thanks,
André
