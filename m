Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZIGQIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZIGQIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 12:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZIGQIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 12:08:31 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:60415 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbZIGQIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 12:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=mJ99PyPw2gZEjRV0mqgmeqV7/wUClFltXzLmUvMWjqvEquALadTksr7qNg5Wany6o1
         ty+7zBCPIWkcFZ2srB/RbyZQSKRcTHfUmxPLo/uuwaQbLDi//v2VjO8lIZJZTiXpn20m
         xeAChHGHTFnCrsxRadS0RpmdP+iKl014ScFR4=
MIME-Version: 1.0
In-Reply-To: <1252243938.4136.26.camel@utx.utx.cz>
References: <20090906052840.GF1324@ucw.cz> <1252243938.4136.26.camel@utx.utx.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 8 Sep 2009 00:08:13 +0800
Message-ID: <f17812d70909070908l26541562iec36a117c155aa08@mail.gmail.com>
Subject: Re: zaurus c3000 aka spitz: fix resume
To: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com,
       Russell King <rmk@arm.linux.org.uk>, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
       eric.miao@marvell.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 6, 2009 at 9:32 PM, Stanislav Brabec<utx@penguin.cz> wrote:
> Pavel Machek wrote:
>> sharpsl_pm.c code tries to read battery state very early during
>> resume, but those battery meters are connected on SPI and that's only
>> resumed way later.
>>
>> Replace the check with simple checking of battery fatal signal, that
>> actually works at this stage.
>
> Tested on:

Applied to 'fix'.
