Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZCWIP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZCWIP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbZCWIPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:15:13 -0400
Received: from ozlabs.org ([203.10.76.45]:52493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbZCWIPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:15:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [git-pull -tip] x86: cleanup patches 20090322
Date: Mon, 23 Mar 2009 18:45:04 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1237755176.5417.16.camel@ht.satnam>
In-Reply-To: <1237755176.5417.16.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231845.05394.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009 07:22:56 Jaswinder Singh Rajput wrote:
>       x86: e820.h fix various signedness issues in setup.c and e820.c

Wouldn't fixing the users be better than changing the header?  Esp. since
it could well now cause similar warnings in userspace programs.

>  struct e820map {
> -	__u32 nr_map;
> +	__s32 nr_map;
>  	struct e820entry map[E820_X_MAX];
>  };

This number can't be negative!

Cheers,
Rusty.
