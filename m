Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbZDHRP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbZDHRP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZDHRPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:15:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:11956 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbZDHRPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:15:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RXegdHyn2nb2H5dqgJgG0d3ZodvxVQYFlNuC4WZ++K+qIe7se8lFIzhWQITpGX+Nwt
         ZiQtkTlzXDnUJJCm+6htxdHoRhpdUHV4ceqhKL0t4lwQ7QkGoe/Gy/gFslUbA72qZROW
         7OnObJg5SDS1sHwaVuHRSlLpqKGplNL+/GPas=
MIME-Version: 1.0
In-Reply-To: <a4423d670904081012j30ad104etefeee0c8c682aca9@mail.gmail.com>
References: <a4423d670904081012j30ad104etefeee0c8c682aca9@mail.gmail.com>
Date: Wed, 8 Apr 2009 19:15:39 +0200
Message-ID: <19f34abd0904081015r5549da00w97593be16373bb8c@mail.gmail.com>
Subject: Re: 2.6.30-rc1 cannot boot: scsi/async
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/8 Alexander Beregalov <a.beregalov@gmail.com>:
> Hi
>
> It is 2*2 SMP system, x86_64.
>
> INFO: task async/0:1073 blocked for more than 120 seconds.


Hi,

I just proposed a patch to fix this:

http://marc.info/?l=linux-kernel&m=123920746830420&w=2

Don't know if it's correct or whether it actually fixes the problem,
but you are welcome to try it :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
