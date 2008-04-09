Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbYDIU2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbYDIU2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYDIU2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:28:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:20076 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYDIU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:28:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gzMnZ7541HpViLd76Q70iy+cSCC/mufTIahgEJ9zwFFd/WRzj/OECkc54L+UbmavKru/hjIYn1WxTijK+a5vPy6LgkAkaXmTpzNBfloS7HpCaZyyRIniSI5nTnx6ICDHRSKsHobmdVhAvVYia4QunkH9SZiQR56IftCCXGA4PkA=
Message-ID: <86802c440804091328s4127422dk593384c32ba56e88@mail.gmail.com>
Date: Wed, 9 Apr 2008 13:28:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
Cc: "Alan Mayer" <ajm@sgi.com>, torvalds@linux-foundation.org,
       "linux-kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080409145945.GB17100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.SGI.3.96.1080408160826.8706317D-100000@fergus.americas.sgi.com>
	 <20080409145945.GB17100@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2008 at 7:59 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Alan Mayer <ajm@sgi.com> wrote:
>
>  > Subject: [PATCH] x86_64: Change FIRST_SYSTEM_VECTOR to a variable.
>  >
>  > From: Alan Mayer <ajm@sgi.com>
>  >
>  > The SGI UV system needs several more system vectors than a vanilla
>  > x86_64 system.  Rather than burden the other archs with extra system
>  > vectors that they don't use, change FIRST_SYSTEM_VECTOR to a variable,
>  > so that it can be dynamic.
>
>  nice - but please split this up into two patches: first one that changes
>  the generic code to use a variable limit - this patch will (should) be a
>  functional NOP.
>
>  then a second patch adds those two new UV vectors.
>
>  Also, could you please also change the 32-bit side as well so that we at
>  least keep the two implementations roughly in sync?
>

for x86_64, current from 0x20 to 0x2f, we only use one for irq migration.

wonder if you can use 2 from them for UV...

YH
