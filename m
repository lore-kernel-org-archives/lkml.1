Return-Path: <linux-kernel-owner+w=401wt.eu-S1422773AbXBAKoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422773AbXBAKoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 05:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422780AbXBAKoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 05:44:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422773AbXBAKoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 05:44:07 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6> 
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6> 
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h. 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 01 Feb 2007 10:43:59 +0000
Message-ID: <3565.1170326639@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Robert P. J. Day <rpjday@mindspring.com> wrote:

> +#define is_power_of_4(x)	is_power_of_2(x) && (ffs(x) & 1))

If this is such a commonly implemented op, it should probably be implemented
globally too.

I also wonder if there's some better way of implementing it than this, but I
can't think of one offhand.

David
