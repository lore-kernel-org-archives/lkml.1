Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbZEQIMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbZEQIMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 04:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZEQIMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 04:12:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:55858 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZEQIMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 04:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=s6x6Azu9dwwrLxxs9H469ztcuWiT+ZHT+k8dKMe1YZGVVE4s2V7QITeUS88903ZHWI
         9VNJytRlNqT706aDsPVLIFmCbmm/xKukG+j4yK/0K48q+k1GXV2+k711Y+jZkfVSSJdM
         +8rNfvFhB+LZnLMZK1HXjzLK7FxQaxpB2cXnQ=
MIME-Version: 1.0
In-Reply-To: <1240594638.4777.1.camel@localhost.localdomain>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	 <nY3-4PrO6XH.A.QZB.ow85JB@chimera>
	 <1240594638.4777.1.camel@localhost.localdomain>
Date: Sun, 17 May 2009 11:12:35 +0300
X-Google-Sender-Auth: 806dfab35c648076
Message-ID: <84144f020905170112l789e9ec0p2bf6bb71879579e1@mail.gmail.com>
Subject: Re: [Bug #13069] regression in 2.6.29-git3 on SH/Dreamcast
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 23:45 +0200, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.29.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13069
>> Subject               : regression in 2.6.29-git3 on SH/Dreamcast
>> Submitter     : Adrian McMenamin <adrian@newgolddream.dyndns.info>
>> Date          : 2009-03-29 19:04 (19 days old)
>> References    : http://marc.info/?l=linux-kernel&m=123835353115372&w=4

On Fri, Apr 24, 2009 at 8:37 PM, Adrian McMenamin
<adrian@newgolddream.info> wrote:
> At this point it *looks* as though it was simply a question of
> insufficient memory to boot, but I think it needs further testing.
> Nobody else seems to have picked it up though.

Yeah, it looks like there's not enough memory to boot. It could well
be that the kernel memory footprint got bigger but I don't think the
bisected commit is at fault here. Perhaps we should just close the
bug?
