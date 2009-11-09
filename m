Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZKIPbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZKIPbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZKIPbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:31:41 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:55167 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbZKIPbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:31:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=j3tf1pNG+uCkL+ygqbFg6VU42cJz6YBhu+S9g50IaY58mWIYH/mUZupgb+NULTZAAw
         TZBdvD9Mnju624hm7gG1yGcpEDX6xqJlas1Alqq7JQWgGrzziLBOrIuxiP9F8Ua3aHTr
         cm2F+p92CfGcTHzXoMc5ukVYfKDAVn5WnKeBE=
MIME-Version: 1.0
In-Reply-To: <31525.1257770343@redhat.com>
References: <cover.1257602781.git.andre.goddard@gmail.com> 
	<7206ef594e67a240a842339f520284de6569b1fc.1257602781.git.andre.goddard@gmail.com> 
	<31525.1257770343@redhat.com>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 9 Nov 2009 13:31:25 -0200
Message-ID: <b8bf37780911090731rf6aa60au61448337e0431100@mail.gmail.com>
Subject: Re:
To: David Howells <dhowells@redhat.com>
Cc: linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 9, 2009 at 10:39 AM, David Howells <dhowells@redhat.com> wrote:
> MIME-Version: 1.0
> Content-Type: text/plain; charset=iso-8859-1
> Content-Transfer-Encoding: quoted-printable
>
> Andr=E9 Goddard Rosa <andre.goddard@gmail.com> wrote:
>
>> It decreases code size:
>>    text    data     bss     dec     hex filename
>>   15719       0       8   15727    3d6f lib/vsprintf.o-before
>>   15543       0       8   15551    3cbf lib/vsprintf.o-after
>
> Whilst this may be true, there will be a countervailing decrease in
> performance.  Have you assessed that?

(trimmed long cc: list to keep it sane, I'll not use get_maintainer.pl
output this way anymore)

I'm not sure it decreases performance. From the last iteration of the
patch, I removed
the hint to force "not inlining", so that gcc can inline it if it
thinks it's better.

Are those so performance sensitive that it makes sense to perform this
assessment?
If you think so, what would you suggest? A micro-benchmark or some
real use case?

Best regards,
André
