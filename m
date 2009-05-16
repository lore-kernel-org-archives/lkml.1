Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbZEPPxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbZEPPxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 11:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZEPPxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 11:53:45 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:47307 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZEPPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 11:53:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Security] [patch] random: make get_random_int() more random
Date: Sat, 16 May 2009 17:54:01 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>, security@kernel.org,
       Linux@hera.kernel.org, stable@kernel.org,
       Cox <alan@lxorguk.ukuu.org.uk>, Arjan@hera.kernel.org,
       List <linux-kernel@vger.kernel.org>, Alan@hera.kernel.org,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Matt Mackall <mpm@selenic.com>, Dave Jones <davej@redhat.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, de Ven <arjan@infradead.org>
References: <20090505202219.GL31071@waste.org> <20090516135828.GA25283@1wt.eu> <alpine.LFD.2.01.0905160811550.3301@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905160811550.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905161754.03472.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 16. Mai 2009 17:23:11 schrieb Linus Torvalds:
> (That's especially true since whatever we do, the _one_ thing we can never
> do is to actually hide what hash we use. We can hide the data, but we
> can't hide the code. Others depend on also making it harder to guess
> even what the algorithm for the hash itself is).

Why can't we implement more than one hash and choose at boot time?
Or even change the hash on the fly? That's not as good as a secret
algorithm, but the attacker would have to guess which is used.

	Regards
		Oliver

