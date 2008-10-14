Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbYJNRCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYJNRCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 13:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYJNRCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 13:02:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50139 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYJNRCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 13:02:17 -0400
Date: Tue, 14 Oct 2008 12:59:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Message-ID: <20081014165931.GC3349@tuxdriver.com>
References: <20081014010202.71d13eaf@werewolf.home> <20081013232432.GB32550@tuxdriver.com> <20081014014406.318db8e7@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081014014406.318db8e7@werewolf.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 01:44:06AM +0200, J.A. Magallón wrote:
> On Mon, 13 Oct 2008 19:24:33 -0400, "John W. Linville" <linville@tuxdriver.com> wrote:

> > config WIRELESS_OLD_REGULATORY
> > 	bool "Old wireless static regulatory definitions"
> ...
> > 
> > Is this not clear enough?
> > 
> 
> NO.
> 
> I'm a complete literate in wireles internals. Not in other areas. And I
> don't undestand a word about regulations and so on. The only thing
> I see there is 'OLD WAY of doing things', so I disable it. I expect
> two things:

You blindly disable things because they say "old", you don't update
anything in your userland, and then you expect things to work?

> - As it is an optional thing I can toggle, no driver depends on it.
> - If I choose a driver that depends on it, it will get automagically
>   selected.

And this fits neither of your scenarios.  The drivers will work just
fine with the code as you built it -- even better if you update your
userland with the required component.

The problem is that you were setting a module option that no longer
existed because you didn't want to do things the "old" way.  Should we
support a useless module option, even when you expressly disable the
compatibility option that provides it?

> So, please, if migration is not finished:
> 
> - Default it as Y, or add a depend on every driver that uses it
> - Hide it under the famous 'crazy hacker-only things' boolean

Neither of these are necessary -- just stop specifying the module
option that doesn't exist, or simply enable the compatibility option
in the kernel.

> It is enough to have to choose between mac80211 and ieee80211.

Perhaps we should change the name of "ieee80211" to
"old_ipw2x00_support_crap"?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
