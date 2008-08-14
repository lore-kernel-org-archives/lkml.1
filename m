Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYHNInM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYHNInM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYHNIm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:42:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:18216 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYHNIm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:42:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JAxQHlGZdYL/2vlU/iEwG6N1kCe5WitGzfKTsHE+TkVAuuGY4WuBObOtTosU4+zf0G
         yfYmF8iA6WVkU1gwagHlh3HpNzyEioI2XTia94wY0WZKQFrfAlR4j6riCou7gHtgKOl4
         PJqehNPHo68h0gHvtoziI3QApLlBHGdvMdceI=
Message-ID: <520f0cf10808140142m387f59faka4287aef7d18a7ae@mail.gmail.com>
Date: Thu, 14 Aug 2008 10:42:55 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: drop overzealous ERROR: do not initialise statics to 0 or NULL from checkpatch.pl
Cc: "Arnd Bergmann" <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
       "Andy Whitcroft" <apw@shadowen.org>, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
In-Reply-To: <Pine.LNX.4.64.0808132216460.7713@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <520f0cf10808130339r5dd22e12w3477d6bddd545db1@mail.gmail.com>
	 <200808131415.36851.arnd@arndb.de>
	 <Pine.LNX.4.64.0808132216460.7713@axis700.grange>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 10:19 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 13 Aug 2008, John Kacur wrote:
>
>> Could we drop this somewhat overzealous "ERROR: do not initialise
>> statics to 0 or NULL" from checkpatch.pl?
>>
>> Reasoning:
>> 1. This is not part of Documentation/CodingStyle
>> 2. K&R 2nd.ed do it (pg 83, static int bufp = 0;) The purpose is to
>> remove access to the bufp from external routines, and to avoid name
>> conflict)
>
> No, "static" "removes access to the bufp from external routines, and
> avoids name conflict", not the initialization to 0.
>

That is true, but the point is that even the folks who invented the
language don't have a problem with making the initialization explicit.
I'm not even trying to argue that folks should do it one way or the
other, I'm just saying it is unimportant, so let's drop it from
checkpatch.pl and save ourselves a lot of pointless code churn.
btw, see pg 94 of "The Practice of Programming" where the masters also
explicitly initialize statics.
