Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZEOBCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZEOBCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 21:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbZEOBBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 21:01:53 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:27366 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbZEOBBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 21:01:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JopXAaCu4feIfWblg2znhhgKglZkZw1w5ffBsBC57A65YlAwHPtvmN1QugQPeSWBmi
         BUMwVgp8npNLmDVGikmlQCb7Xqn1niBirFr2X0trBh3SjLQpvYSZMzZZ8MVBDuQxdHRK
         G5Eoux7iMrlN1grui20tH4eOKnsJ66CK+lTR0=
MIME-Version: 1.0
In-Reply-To: <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com> 
	<4A0B858F.3080405@garzik.org> <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com> 
	<4A0B9B0D.6080006@garzik.org> <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 15 May 2009 11:01:33 +1000
Message-ID: <646765f40905141801k5ae6249p925a4a377652c62e@mail.gmail.com>
Subject: Re: [RFQ] New driver architecture questions
To: adam radford <aradford@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, "Mukker, Atul" <Atul.Mukker@lsi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 10:58, adam radford <aradford@gmail.com> wrote:
> On Wed, May 13, 2009 at 9:16 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> Taking drivers/net/e1000e as an
>> example,
>>
>>        hw.h            hardware-specific defines, ~cross-OS
>>        82571.c         code specific to 8257x chip family, ~cross-OS
>
> 82571.c contains Linux specific code such as:  including Linux
> specific header files, calls to msleep().
>
>>        ich8lan.c       code specific to ICH8+ chip family, ~cross-OS
>
> ich8lan.c contains Linux specific code such as:  might_sleep(),
> mutex_trylock(), mutex_unlock(), udelay(), msleep(), writel(), readl().
>
> Perhaps this is a bad example?  It seems like the "common layer"
> sections that are "cross-OS" shouldn't contain any Linux specific code at all.

I think the implication is that the cross-OS parts are coded, as it
happens, in the linux coding style, using linux functions, but then a
Windows layer maps these to Windows specific functions.

E.g. msleep(), mutex_trylock(), etc are implemented in the Windows
layer by mapping them to the Windows functions to do the same.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
