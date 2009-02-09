Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbZBIKSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbZBIKSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbZBIKR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:17:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:55546 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbZBIKR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:17:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j9v2hfnRO1gTRclpyIEb0IBEClWIInfgUASXVJDSCfRiax8M+cZtqDM0yiKuwSuMxq
         dBC4vGBBAKO2011KP9UrVHlF+aZPT1uR0YHAh5KZne9beyFLBMO3NU2jC+u8FIcRgxSK
         cijUzR3ho0xCOI7Uqb9HqLVcVTOb9ay5EQCpg=
MIME-Version: 1.0
In-Reply-To: <sWhNs83kKPE.A.7EE.O20jJB@chimera>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	 <sWhNs83kKPE.A.7EE.O20jJB@chimera>
Date: Mon, 9 Feb 2009 11:17:55 +0100
Message-ID: <c43b2e150902090217p6efe5141q4b3a608a00c02f71@mail.gmail.com>
Subject: Re: [Bug #12664] viafb triggers BUG at mm/vmalloc.c:294
From: wixor <wixorpeek@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was no support for Chrome9 framebuffer before 2.6.28, so that is
a progress. However now that we have it, it doesn't work (at least for
me).... The BUG appearing seemed to be an mm-issue also reported by
others (see http://marc.info/?l=linux-kernel&m=123415925903748&w=2). I
don't know if it was there before 2.6.28. It doesn't look like any
solution has been merged to mainline.

It is certainly an issue, but I'm not sure if it's also a regression
from 2.6.28.

--
wixor
