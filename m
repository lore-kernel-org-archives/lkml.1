Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbZEHNqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbZEHNqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 09:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZEHNqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 09:46:09 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:42349 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZEHNqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 09:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FKY4QS7Zsr+7t1WZVnRoVAd+XS01NjrAIHwOOvpKOH9ZJVb9xal1879N+rqDarBKa2
         QaNco8QDP3CEMpirVvXBGfMU2PTXa/dIlbUD6uLk4bQmpMr3HNuA3+nmF+lYJgmRtbdh
         zhq/pRHebAinlw4YSVw1JFOLuCd0zfiwi7dLk=
MIME-Version: 1.0
In-Reply-To: <87vdobq48p.fsf@fzidpc73.tu-graz.ac.at>
References: <87vdobq48p.fsf@fzidpc73.tu-graz.ac.at>
Date: Fri, 8 May 2009 14:46:05 +0100
Message-ID: <9b2b86520905080646r85f30bcp6f50d7388d8289f5@mail.gmail.com>
Subject: Re: Asus Eee 901Go ACPI errors on 2.6.30-rc4-git4
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Lang <mlang@tugraz.at>
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/09, Mario Lang <mlang@tugraz.at> wrote:
> Hi.
>
> Booting 2.6.30-rc4-git4 on an Asus Eee 901Go I get the following in dmesg:
>
> [   27.005071] ACPI: EC: missing confirmations, switch off interrupt mode.
> [   27.548097] ACPI Exception (evregion-0422): AE_TIME, Returned by Handler
> for [EmbeddedControl] [20090320]
> [   27.548139] ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.SBRG.EC0_.BST1] (Node f7033d4c), AE_TIME
> [   27.548280] ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.CBST] (Node f70366f8), AE_TIME
> [   27.548393] ACPI Error (psparse-0537): Method parse/execution failed
> [\_SB_.PCI0.BAT0._BST] (Node f7034c48), AE_TIME
> [   27.548521] ACPI Exception (battery-0385): AE_TIME, Evaluating _BST
> [20090320]

Odd.  Did this happen in 2.6.29?

If so - I think there's only one significant EC change since 2.6.29,
you could try reverting that.

34ff4dbccccce54c83b1234d39b7ad9e548a75dd "ACPI: EC: Separate delays
for MSI hardware"

Alan
