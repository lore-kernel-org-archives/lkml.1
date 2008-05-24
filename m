Return-Path: <linux-kernel-owner+w=401wt.eu-S1764918AbYEXVrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764918AbYEXVrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762968AbYEXVfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:35:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:61861 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762114AbYEXVf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NomOoUfVJkQ3Yd2w4fyJ6Trsmb+jkjkkVr736MU6XGYIMILAdTMdMTVgwcjVjApyk/NJRWmmQzNZ4dDNzRnsbzKgvv0YW4jL56yS1/N3qlJLLRc9MtvDJ8XuE8kijOsnHMxQhDhAMHuU4yenZZcEmwtWGqygQb0i7DpuJIU7cTA=
Message-ID: <19f34abd0805241435o47b55292p49f3bcbe7037b8a5@mail.gmail.com>
Date: Sat, 24 May 2008 23:35:29 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10710] [BISECTED] Lots of "rescheduling IPIs" in powertop
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>, "Andi Kleen" <andi@firstfloor.org>,
       "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <TW_YzGo9TFP.A.6XE.5eIOIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
	 <TW_YzGo9TFP.A.6XE.5eIOIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 10:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10710
> Subject         : [BISECTED] Lots of "rescheduling IPIs" in powertop
> Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> Date            : 2008-05-13 20:42 (12 days old)
> References      : http://marc.info/?l=linux-kernel&amp;m=121071176205864&amp;w=4
>                  http://lkml.org/lkml/2008/5/18/120
> Handled-By      : Andi Kleen <andi@firstfloor.org>
>                  Arjan van de Ven <arjan@infradead.org>
>                  Ingo Molnar <mingo@elte.hu>
> Patch           : http://marc.info/?l=linux-kernel&amp;m=121074826823352&amp;w=4

It has been fixed in mainline and should not still be listed:

commit a738d897b7b03b83488ae74a9bc03d26a2875dc6
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 08:47:40 2008 +0200

    x86: remove mwait capability C-state check

Thanks :-D


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
