Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbYDPWu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbYDPWu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYDPWuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:50:18 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:40622 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYDPWuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LOGNNMhoQlHTaJfTAHHwI8k8QngZWrxLVEztAk3HTruS6i+eLUkUkOztQn6mKIy9Ihda4o5PgI4whdKaFfhmAZxK+YtE/etxdq3hMWG91LKhtRsGBGuMl06L1ClpQ11fwPMNLxSDiiYg138V/4eGqLekoAUMpSN2CDh7twg2yO0=
Message-ID: <86802c440804161550r32186d07s36ba8c2e48e52281@mail.gmail.com>
Date: Wed, 16 Apr 2008 15:50:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Pavel Machek" <pavel@ucw.cz>
Subject: Re: gart: factor out common code
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20080416130800.GH6304@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080415104357.GA13441@elf.ucw.cz> <20080416130800.GH6304@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 6:08 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Pavel Machek <pavel@ucw.cz> wrote:
>
>
> > Cleanup gart handling on amd64 a bit: move common code into
>  > enable_gart_translation , and use symbolic register names where
>  > appropriate.
>
>  thanks Pavel, applied.

good, pavel, can you do that on aperture_64.c?
or I will do it.

YH
