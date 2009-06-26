Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZFZFah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZFZFah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 01:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZFZFaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 01:30:30 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:56200 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZFZFaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 01:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nOVvSOB6/9l1cAgLbjh8kh6LpcvHyvNthhsp3ECZIKpNuMPxHOUzhd6BaqGyLtmi6x
         YWnnS8ubgm2dHm0gwfuvJwx5yZ6mlL3YGc67oS7Rp7bgQJgz5F2UH/yyaDNQbnUNc89X
         wumSiy0nvtlq9ZQA6u0OyjUlCoA6qy4aPdqyc=
MIME-Version: 1.0
In-Reply-To: <1245352632.7508.1.camel@localhost.localdomain>
References: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
	 <1245352632.7508.1.camel@localhost.localdomain>
Date: Fri, 26 Jun 2009 14:30:32 +0900
Message-ID: <aec7e5c30906252230s62196e1fr5671aa591f1869a3@mail.gmail.com>
Subject: Re: [PATCH] clocksource: save mult_orig in clocksource_disable()
From: Magnus Damm <magnus.damm@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, lethal@linux-sh.org,
       tglx@linutronix.de, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 4:17 AM, john stultz<johnstul@us.ibm.com> wrote:
> On Fri, 2009-06-19 at 00:24 +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@igel.co.jp>
>>
>> Save clocksource mult_orig in clocksource_disable().
>>
>> To fix the common case where ->enable() does not setup
>> mult, make sure mult_orig is saved in mult on disable.
>>
>> Also add comments to explain why we do this.
>>
>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>
> Acked-by: John Stultz <johnstul@us.ibm.com>
>
> Thomas, Andrew, please push this for 2.6.31.

This one is slowly making it's way in I suppose?

/ magnus
