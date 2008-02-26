Return-Path: <linux-kernel-owner+w=401wt.eu-S1763263AbYBZRFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763263AbYBZRFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYBZREx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:04:53 -0500
Received: from khc.piap.pl ([195.187.100.11]:36068 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbYBZREx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:04:53 -0500
To: davids@webmaster.com
Cc: <Valdis.Kletnieks@vt.edu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@redhat.com>
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
References: <MDEHLPKNGKAHNMBLJOLKGEKDKKAC.davids@webmaster.com>
	<m3d4qj90zm.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 26 Feb 2008 18:04:51 +0100
In-Reply-To: <m3d4qj90zm.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Tue\, 26 Feb 2008 16\:43\:57 +0100")
Message-ID: <m34pbv8x8s.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One may say _GPL is a strong indication that all users are
> automatically a derivative works, but it's only that - indication. It
> doesn't mean they are really derivative works and it doesn't mean a
> module not using any _GPL exports isn't a derivative.

Actually I think the _GPL exports are really harmful - somebody
distributing a binary module may claim he/she doesn't violate the GPL
because the module uses only non-GPL exports. OTOH GPL symbols give
_us_ exactly nothing.
-- 
Krzysztof Halasa
