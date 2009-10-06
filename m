Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbZJFVWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbZJFVWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbZJFVWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:22:25 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:56144 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170AbZJFVWY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:22:24 -0400
X-Greylist: delayed 59109 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 17:22:24 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=U61/lSz8hh5bi3ZfJYnovdU9t/8SvQFoyQCU/Vh0Zxlt/UudiYGck0OOaYOdz3Q+mR
         J7tIhXqV8RktnUFm0gE68vHJPZxr8TlzUZWS2VYnHPNeBSwFm8hOQ3haAOtPpyk0chNR
         Q3Kbb2ro6/wIP+gOaZdB3v+8pcqdtwW3zlfbo=
MIME-Version: 1.0
In-Reply-To: <20091006174411.GB15751@auslistsprd01.us.dell.com>
References: <1254808627-3889-1-git-send-email-vapier@gentoo.org> 
	<1254814818-15658-1-git-send-email-vapier@gentoo.org> <20091006174411.GB15751@auslistsprd01.us.dell.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 6 Oct 2009 17:21:28 -0400
Message-ID: <8bd0f97a0910061421p9b325d4v441c26cffcc3ae91@mail.gmail.com>
Subject: Re: [PATCH v3] firmware: only allow EDD on x86
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 13:44, Matt Domsch wrote:
> On Tue, Oct 06, 2009 at 03:40:18AM -0400, Mike Frysinger wrote:
>> Rather than have the EDD depend on !ia64 (and assuming that only ia64,
>> x86, x86_64 will be including this Kconfig), have EDD depend on the only
>> arches which can support this code.  This should allow all other arches
>> to cleanly include the firmware Kconfig.
>>
>> Also simplify the x86 string used by FIRMWARE_MEMMAP to match EDD.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> Acked-by: Matt Domsch <Matt_Domsch@del.com>

guessing you meant @dell.com :)
-mike
