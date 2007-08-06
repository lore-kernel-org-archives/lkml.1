Return-Path: <linux-kernel-owner+w=401wt.eu-S1765566AbXHFVs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765566AbXHFVs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbXHFVsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:48:47 -0400
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:36714
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758186AbXHFVsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:48:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=D8XKvaQ4V+Y+zyOC3EOOh5Nf358FAaytjSpwyzZXFxhB9LjVgmpOZumdHUe3Gjgg;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000b01c7d873$76ce03c0$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: "Rene Herman" <rene.herman@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "\"T. J. Brumfield\"" <enderandrew@gmail.com>
Subject: Re: about modularization
Date: Mon, 6 Aug 2007 14:48:01 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec796def738cda18bc701921b999a9856f94350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.93.68
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene,

    Of the uni-processor systems currently that can run Linux, I would not
    doubt if  99.9999% percent are uni-cores. It will be probably
    3-5 years minimum before the multi-core processors will have any
    decent percentage of systems.

    And I am not suggesting not supporting them. I am only suggesting
   is wrt the schedular, bring the system up with a default schedular,
   and then load additional functionality based on the hardware/software
    requirements of the system.

    Thus, the fallout MIGHT be a uni-processor CFS that would not migrate
    tasks between multiple CPUs and as additional processors are brought
    online, migration could be enabled, and gang type scheduling,  whatever
    could be then used.


    IMO, if their is a fault (because of heat, etc) the user would rather
bring
    up the system in a degraded mode. Same reason applies to...
    boot -s..

    Mitchell Erblich
------------------------------


Rene Herman wrote:
>
> On 08/06/2007 10:20 PM, Mitchell Erblich wrote:
>
> >     Thus, a hybrid schedular approach could be taken
> >     that would default to a single uni-processor schedular
>
> What a brilliant idea in a world where buying a non multi core CPU is
> getting to be only somewhat easier than a non SMT one...
>
> Rene.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

