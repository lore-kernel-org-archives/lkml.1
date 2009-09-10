Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZIJKhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZIJKhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZIJKhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:37:21 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:52844 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZIJKhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P0rzi2r3SzqEMPmDcawm7ZllepJVBEDY+Q+21fQJuZeFixkrUCUJOaYJ+e9wf9MZTx
         +H695++Pa/H82rsq8EKDSq8Wtw9uOHG5gJ9aFLsR35VlZSb1yR4lmeqwfF7ThZqU+I8R
         qB3D4iCY2J8BcVDoWrLs7DsBsHmrExkkP84Hs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0909101228170.9074@aurora.sdinet.de>
References: <241b8f7b0909100310t267b82cq976929d2f7b7734@mail.gmail.com>
	 <alpine.DEB.2.00.0909101228170.9074@aurora.sdinet.de>
Date: Thu, 10 Sep 2009 16:07:24 +0530
Message-ID: <241b8f7b0909100337sc47f6a6yf1488d1bd7f17a00@mail.gmail.com>
Subject: Re: disable : Ctrl -C in the Kernel
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thansk,

Do u know which is enabling it.

Coz, after adding the line told by u, I am not able to  disable, means
somewhere after this place its being enabled.



On Thu, Sep 10, 2009 at 3:59 PM, Sven-Haegar Koch <haegar@sdinet.de> wrote:
> On Thu, 10 Sep 2009, Prabhu Chawandi wrote:
>
>>   I am running Some application at the end of rcS script file.
>>
>> I need to disable Ctrl-c, i.e.  application should not kill after Ctrl-c.
>>
>> and in some case I want Ctrl-C to work normally.
>>
>> I am taking care in application about catching signal using signal(),
>> even then I think there is something from kernel side.
>>
>> Can any one help ?????/
>
> We are using the following command here in an rc script early at boot to
> disable Ctrl-C:
>
>        stty intr ^@ quit ^@ susp ^@
>
> c'ya
> sven
>
> --
> The lights are fading out, once more...
>
