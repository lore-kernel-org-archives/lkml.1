Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbYDUVro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbYDUVro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYDUVrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:47:33 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:45676 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752814AbYDUVrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:47:32 -0400
Date: Mon, 21 Apr 2008 23:29:23 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Andrew Paprocki <andrew@ishiboo.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: kernel BUG at /usr/src/linux-2.6.25/kernel/workqueue.c:224!
	(r8169?)
Message-ID: <20080421212923.GB2931@electric-eye.fr.zoreil.com>
References: <76366b180804201548g309ae6cci286ed6552f3cb71e@mail.gmail.com> <76366b180804202016l19ac362cyb814781449f81e9a@mail.gmail.com> <20080421203458.GA2931@electric-eye.fr.zoreil.com> <76366b180804211422k33057607p586b5deed7849c07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76366b180804211422k33057607p586b5deed7849c07@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Paprocki <andrew@ishiboo.com> :
[...]
> On this kernel CONFIG_R8169_NAPI is disabled, so that code would not
> even be compiled in. Is NAPI stable enough that I should be using it
> now ?

Yes.

> (It is still marked experimental)

I'll remove the non-NAPI code. It's long overdue.

-- 
Ueimor
