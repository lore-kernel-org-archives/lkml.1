Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbYIHP0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbYIHP0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYIHP01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:26:27 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:15239 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYIHP01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kZ+WEftZ/TZUyur/5ub+COE0LqxDmJMY6SW5q6ZewUkC8dEaP9w4MRAynUklQbZpJF
         uPmtgAFnc1GHDxSc+1ihopiN0GbRL+FaMase3jCoQTYBAzbUmFYTANxRj38OB9YZmgOv
         gQEdCZ+q//kmG5Ofxf2IU8Ds1M4vs67ES8P9o=
Message-ID: <19f34abd0809080826s758a212x22f17e1836e27e2@mail.gmail.com>
Date: Mon, 8 Sep 2008 17:26:25 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [GIT PULL] kmemcheck updates for tip/kmemcheck
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0809080824k4dc5e4faq777f7fb3b5fe05fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080907200943.GA2665@localhost.localdomain>
	 <20080908151753.GE10580@elte.hu>
	 <19f34abd0809080824k4dc5e4faq777f7fb3b5fe05fe@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 5:24 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Mon, Sep 8, 2008 at 5:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> +#if defined(CONFIG_SMP) && !defined(CONFIG_KMEMCHECK_USE_SMP)
>
> Should really be just:
>
> +#if defined(CONFIG_SMP)
>
> Can you amend?

Er, also written like:

+#ifdef CONFIG_SMP

Bonk.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
