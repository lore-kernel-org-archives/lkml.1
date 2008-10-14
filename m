Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbYJNJei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbYJNJei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYJNJe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:34:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:1319 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbYJNJe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=t5nLjUEK8UlVKHqTyODvtOS+Uz0GYgSq7UeslZe8/qB9P81ArZtnUfIWesTRXGaIwU
         p7GmkAhan+aaDkX60Th+ID0GnRh0hjM5dm9nb7tlHFEa9TEV+gLZ0WADIgJkGhxOfBLj
         SoK8b+6dV6B0QrMjzbK3RnaI9SCml9Un6dHYk=
Message-ID: <68676e00810140234o5e85f438l18058c907a7c6260@mail.gmail.com>
Date: Tue, 14 Oct 2008 11:34:28 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: SDHCI: timeout during data transfer
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081012105227.513bb9a8@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080923212459.GA13888@dreamland.darkstar.lan>
	 <20081002101754.031d6710@mjolnir.drzeus.cx>
	 <68676e00810030427g63c07643rf637ca894df795b2@mail.gmail.com>
	 <20081012105227.513bb9a8@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 10:52 AM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Fri, 3 Oct 2008 13:27:52 +0200
> "Luca Tettamanti" <kronos.it@gmail.com> wrote:
>>
>> Hum, cannot reproduce (but it was consistently failing when I tested
>> the patch... the only difference is a mkfs in between). I just got a
>> few retries:
>
> A silly question, but did you also try disabling the debugging? Since
> this is a timing issue, the debugging output could be just enough to
> make the problem go away.

Ok, I managed to reproduce without the debugging, but this time it
took over a couple of GB before it started failing. Block numbers
differ from the previous failures (so maybe it's not a cluster of
broken blocks).
Will go back and test with debugging enabled.

Luca
