Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbZH3UiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbZH3UiF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZH3UiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:38:04 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:39856 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbZH3UiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:38:03 -0400
Date: Sun, 30 Aug 2009 22:37:35 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Dillow <dave@thedillows.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Rui Santos <rsantos@grupopie.com>,
       Michael B??ker <m.bueker@berlin.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Reduce looping in the interrupt handler.
Message-ID: <20090830203735.GA24912@electric-eye.fr.zoreil.com>
References: <1251294974.14241.9.camel@obelisk.thedillows.org> <1251295175.14241.11.camel@obelisk.thedillows.org> <m11vmy737x.fsf@fess.ebiederm.org> <20090826213024.GA20428@electric-eye.fr.zoreil.com> <m1hbvu45jq.fsf@fess.ebiederm.org> <20090827052423.GA1709@electric-eye.fr.zoreil.com> <m1ocq1ke9u.fsf@fess.ebiederm.org> <20090827232024.GA30119@electric-eye.fr.zoreil.com> <m1d46gka9e.fsf@fess.ebiederm.org> <1251422978.21865.2.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251422978.21865.2.camel@obelisk.thedillows.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Dillow <dave@thedillows.org> :
[...]
> It'll be this weekend, but I can see cases where it can lock my chip up
> -- they should be rare, but then I thought your case would be extremely
> rare...

I don't get it.

Can you elaborate the relevant cases or give some sample scenarios for
them ?

-- 
Ueimor
