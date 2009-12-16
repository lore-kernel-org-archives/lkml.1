Return-Path: <linux-kernel-owner+w=401wt.eu-S933600AbZLPP7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600AbZLPP7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932720AbZLPP7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:59:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43699 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbZLPP7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:59:40 -0500
Date: Wed, 16 Dec 2009 16:59:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Michael Stone <michael@laptop.org>
Cc: Ulrich Drepper <drepper@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>
Subject: Re: [PATCH] Security: Add prctl(PR_{GET,SET}_NETWORK) interface.
Message-ID: <20091216155938.GG15031@basil.fritz.box>
References: <1260977452-2334-1-git-send-email-michael@laptop.org> <1260977565-2379-1-git-send-email-michael@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260977565-2379-1-git-send-email-michael@laptop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 10:32:43AM -0500, Michael Stone wrote:
> Daniel Bernstein has observed [1] that security-conscious userland processes
> may benefit from the ability to irrevocably remove their ability to create,
> bind, connect to, or send messages except in the case of previously connected
> sockets or AF_UNIX filesystem sockets. We provide this facility by implementing
> support for a new prctl(PR_SET_NETWORK) flag named PR_NETWORK_OFF.
> 
> This facility is particularly attractive to security platforms like OLPC
> Bitfrost [2] and to isolation programs like Rainbow [3] and Plash [4].

What would stop them from ptracing someone else running under the same
uid who still has the network access? If you ptrace you can do
arbitary system calls.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
