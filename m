Return-Path: <linux-kernel-owner+w=401wt.eu-S1422786AbXBAKuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422786AbXBAKuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 05:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422782AbXBAKuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 05:50:35 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:36671 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422786AbXBAKue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 05:50:34 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 1 Feb 2007 05:49:28 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: David Howells <dhowells@redhat.com>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       galak@kernel.crashing.org
In-Reply-To: <3565.1170326639@redhat.com>
Message-ID: <Pine.LNX.4.64.0702010546400.13434@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
  <3565.1170326639@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007, David Howells wrote:

>
> Robert P. J. Day <rpjday@mindspring.com> wrote:
>
> > +#define is_power_of_4(x)	is_power_of_2(x) && (ffs(x) & 1))
>
> If this is such a commonly implemented op, it should probably be implemented
> globally too.

there are only two checks of the form "is_power_of_4" in the entire
tree, and they're both in the power pc stuff, so i doubt it's worth
trying to formalize that in any way.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
