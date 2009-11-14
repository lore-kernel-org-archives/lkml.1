Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZKNHod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZKNHod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 02:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZKNHod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 02:44:33 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:54375 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZKNHoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 02:44:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PjsJvXuhUVLSBiYMFsmYoERFsTjRZWcAUOnA1qkEf8TOCrF75l7OC176a4lYkHKEMu
         xVOerwMdMBNrGPmeCs/muD6SACNXuVoP/xb5L9qP4AZM+VEShdBPs8/rIlzUertabBNE
         m7ymPDsiN94DYs1H1Ou6VgLcvaz9GgwxB/YLs=
MIME-Version: 1.0
In-Reply-To: <20091114042047.GF18847@khazad-dum.debian.net>
References: <cover.1257602781.git.andre.goddard@gmail.com> 
	<7d5883637aa976b54e944998f635d47a41618a75.1257602781.git.andre.goddard@gmail.com> 
	<20091114042047.GF18847@khazad-dum.debian.net>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 14 Nov 2009 16:44:18 +0900
Message-ID: <b8bf37780911132344i5eea1796j18b9170587ff5cb1@mail.gmail.com>
Subject: Re: [ibm-acpi-devel] [PATCH v4 12/12] tree-wide: convert open calls 
	to remove spaces to skip_spaces() lib function
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 14, 2009 at 1:20 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sat, 07 Nov 2009, André Goddard Rosa wrote:
>> Also, while at it, if we see (*str && isspace(*str)), we can be sure to
>> remove the first condition (*str) as the second one (isspace(*str)) also
>> evaluates to 0 whenever *str == 0, making it redundant. In other words,
>> "a char equals zero is never a space".
>
> You didn't document in isspace() that it must return false for NUL.  Please
> do that before you remove any such checks.
>

Good idea Henrique, I will do it!

Thank you,
André
