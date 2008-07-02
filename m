Return-Path: <linux-kernel-owner+w=401wt.eu-S1761512AbYGBCqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761512AbYGBCqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbYGBCqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:46:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:34388 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbYGBCqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tahRkZX4bC5AdvVO7bZs/9Ih6kkLChVBAmZs0GBCNi4PTj23nkUdpjnhiMg6RXf3y0
         rfyDLu/hn5aqyJ2iuyvYGHcH2ipP84PMn8GXqkqshSjlqxwRxGNbdBxMoviObGK8sQAG
         rdnnRWgp6loiOfxSyZ4mK46EjuibNPYdwXKao=
Message-ID: <86802c440807011946m47fcba2h3b10be091fc7547f@mail.gmail.com>
Date: Tue, 1 Jul 2008 19:46:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Miquel van Smoorenburg" <mikevs@xs4all.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200807011939.53427.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080526234940.GA1376@xs4all.net>
	 <200806101014.25089.jbarnes@virtuousgeek.org>
	 <20080626113855.GE29619@elte.hu>
	 <200807011939.53427.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 7:39 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Thursday, June 26, 2008 4:38 am Ingo Molnar wrote:
>> that branch is always based in -git so if stuff goes upstream patches
>> disappear from it. git-log linus/master..tip/pci-for-jesse should tell
>> the currently pending items. Right now it's just two lowprio items:
>>
>>  Yinghai Lu (2):
>>       pci: debug extra pci resources range
>>       pci: debug extra pci bus resources
>
> It looks like these add some new, unconditional debug output?  I guess I
> shouldn't worry about printks so much at this point, given how much
> obsolete/uninteresting info gets dumped these days, but it would be nice if
> this were only dumped if some debug option were set.  Given the variety of
> PCI stuff we might like to dump at various times, maybe it's time we added a
> few new pci=debug=foo options?  Yinghai?
>
that is just limited printout. and it is informative..
that is BAR before kernel try to assign new value to it.

YH
