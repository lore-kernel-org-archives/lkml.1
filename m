Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYFYMEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYFYMEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 08:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758052AbYFYMEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 08:04:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:34994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041AbYFYMEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 08:04:34 -0400
Date: Wed, 25 Jun 2008 14:05:11 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, x86@kernel.org, vgoyal@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] e820_update_range(): Allow specifying ULLONG_MAX
Message-ID: <20080625140511.6660ff68@halley.suse.de>
In-Reply-To: <86802c440806241321g6c5cd64eoe504d6029de6fe5a@mail.gmail.com>
References: <1214318125-32619-1-git-send-email-bwalle@suse.de>
	<1214318125-32619-3-git-send-email-bwalle@suse.de>
	<86802c440806241301x4d124335h2888de9e915208ae@mail.gmail.com>
	<86802c440806241321g6c5cd64eoe504d6029de6fe5a@mail.gmail.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu [2008-06-24 13:21]:
>
> > it seems we should let the caller to use
> > e820_update_range(start, ULLONG_MAX - size,....)
> >
> > so you don't need to touch this func.
> 
> or add sanitary check before using size in this func like
> if (size > ULLONG_MAX - start)
>      size = ULLONG_MAX - start;
> 
> e820_remove_range need to the same thing

I like that. I think the complexity should be in the function, and not
in the caller's function.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
