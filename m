Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbZBOAXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbZBOAXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 19:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZBOAXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 19:23:22 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:40004 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZBOAXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 19:23:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TAoNEGltneonn54GB26mfqV4Dnf1/m5r7kqJwhU/61TDcxEKtE5ARiM08Cun4xGnlF
         uIWH4ktFpf0AN/b6FDUJ0vNH8SZxRT4OUiGCfvHyBg9HpNEcqttgZK/yytLO5rrkIM/5
         jxaNin5Jvk2BIKhz++3ydEJTfY/mvCXK1OjGU=
MIME-Version: 1.0
In-Reply-To: <rjPbZ5GRJPO.A.E3F.xs0lJB@chimera>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
	 <rjPbZ5GRJPO.A.E3F.xs0lJB@chimera>
Date: Sun, 15 Feb 2009 00:23:17 +0000
Message-ID: <8b67d60902141623k449dc769n9fd6bf180d3267d3@mail.gmail.com>
Subject: Re: [Bug #12502] pipe_read oops on sh
From: Adrian McMenamin <lkmladrian@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/14 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12502
> Subject         : pipe_read oops on sh
> Submitter       : Adrian McMenamin <lkmladrian@gmail.com>
> Date            : 2009-01-15 9:48 (31 days old)
> References      : http://marc.info/?l=linux-kernel&m=123201298005600&w=4
>
>
>

No, it was caused by a race condition that has now been fixed.
