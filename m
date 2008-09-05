Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYIEK5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYIEK5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYIEK5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:57:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:36071 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbYIEK5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:57:45 -0400
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: pageexec@freemail.hu
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       hpa@zytor.com
In-Reply-To: <48C10EC5.24400.3008276@pageexec.freemail.hu>
References: <20080903195122.73905236@infradead.org>
	 , <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu>
	 , <1220609647.4879.169.camel@pasglop>
	 <48C10EC5.24400.3008276@pageexec.freemail.hu>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 20:57:11 +1000
Message-Id: <1220612231.4879.175.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> and that'd be because at the same time they patch the syscall table (remember,
> they already have to go to length to get around the read-only pages), they
> can't also patch this 'protection'? sounds really plausible, right :).
> 
> [fixed hpa's address, .org bounces.]

Sure, they can :-)

It's just an idea I had on irc but I tend to agree that it wouldn't have
much effect in practice... regarding security, it will break some
existing rootkits ... until updated ones show up.

Cheers,
Ben.

