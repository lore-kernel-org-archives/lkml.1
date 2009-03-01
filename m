Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbZCABaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbZCABaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 20:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZCAB34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 20:29:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55429 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZCAB3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 20:29:55 -0500
Date: Sun, 1 Mar 2009 02:48:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       mingo@elte.hu, nickpiggin@yahoo.com.au, sqazi@google.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090301014822.GG26292@one.firstfloor.org>
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <20090228092450.3ded2db5@infradead.org> <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain> <20090228.160651.228301019.davem@davemloft.net> <20090301004003.GF26292@one.firstfloor.org> <49A9D6CA.30906@zytor.com> <20090228163811.48b1de72@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228163811.48b1de72@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the entire point of using movntq and friends was to save half the

I thought the point was to not pollute caches? At least that is 
what I remember being told when I merged the patch.

-andi
