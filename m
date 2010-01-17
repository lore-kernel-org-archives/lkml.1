Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145Ab0AQQXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0AQQXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 11:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958Ab0AQQXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 11:23:50 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:63041 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0AQQXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 11:23:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=R+yIyNLfEMOxkYmxSKpAjcAy8HVrBQZ5LUOo4wA1O9aePGA5vgKW+y3T0Slho7WjfY
         r7Xjy4cMMlCc8n0zxWtG2Fp033XKGAdjSYKogk3oxXbgGNmoIHVPiJNXx+3GdQR+eOl0
         w4IroUNN2OZrPDsxtNKtPdJa3Mja/Nhux6ljg=
MIME-Version: 1.0
In-Reply-To: <1263745267.2162.42.camel@barrios-desktop>
References: <1263549544.3112.10.camel@maxim-laptop>
	 <201001162317.39940.rjw@sisk.pl> <201001170138.37283.rjw@sisk.pl>
	 <201001171455.55909.rjw@sisk.pl>
	 <1263745267.2162.42.camel@barrios-desktop>
Date: Mon, 18 Jan 2010 01:23:48 +0900
Message-ID: <28c262361001170823s445591fao1fca4bc539a27125@mail.gmail.com>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume 
	(was: Re: Memory allocations in .suspend became very unreliable)
From: Minchan Kim <minchan.kim@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-mm <linux-mm@kvack.org>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think we can use lockdep annotation, too. but it's overkill.
> That's because suspend/resume is rare event so that I want to add

so that I don't want to add

Sorry for the typo.
-- 
Kind regards,
Minchan Kim
