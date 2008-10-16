Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbYJPWnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbYJPWnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbYJPWnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:43:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:57357 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbYJPWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cTUV1TaFsg2La5cYsg17QVP7GiYEH19TgGlQA27GC+y/lwj1CyygpVyWFEPjVpwK5C
         3yeAtA+uxNG3XE0DsGdaUjG+SBF9t5KVT0WfD2oVXIReWvQK/ZXEgQLusWl+hyc+IAKD
         49T9SOrVZXSAfYK7UHGwi7coMsOeOrySSPoFk=
Message-ID: <c62985530810161543q23f9ae75jb08ff986a214da0@mail.gmail.com>
Date: Fri, 17 Oct 2008 00:43:28 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull] core kernel updates for v2.6.28
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Becky Bruce" <becky.bruce@freescale.com>
In-Reply-To: <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081015125023.GA6702@elte.hu>
	 <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/17 Linus Torvalds <torvalds@linux-foundation.org>:
> The fact is, that second argument was a "ptrdiff_t", which is neither
> "int" nor "long".  It should be "%td" I think. But the thing is, when you
> fix a warning, you should damn well know what the hell you're doing, not
> just shut it up.

Sorry, I made some falses assumptions about the printed type I guess...
