Return-Path: <linux-kernel-owner+w=401wt.eu-S970154AbXFHQ0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970154AbXFHQ0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbXFHQZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:25:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:12037 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbXFHQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:25:53 -0400
Date: Fri, 8 Jun 2007 18:25:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Should "cleanpatch" clean up stretches of space?
In-Reply-To: <46697FD0.9070006@zytor.com>
Message-ID: <Pine.LNX.4.64.0706081822350.10769@fbirervta.pbzchgretzou.qr>
References: <46697FD0.9070006@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 8 2007 09:12, H. Peter Anvin wrote:
>Hi all,
>
>Right now I have "cleanspace" and "cleanpatch" clean up spaces before
>tabs, but it does not compress runs of spaces that aren't followed by a tab.
>
>I could make it do that; I was being conservative when I wrote it and
>opted for it not to do so, but I wanted to hear if people think it
>should (and if so, what should a reasonable threshold be, in addition
>for obviously crossing a tab line?  Two spaces?  Three?  Four?  Eight?)

Exactly. Linus (see CodingStyle) thinks non-8-tabs are heretic movements,
but well, let those people have their fun.
People should not be forced (by means of checker scripts that are officially
endorsed) to compress / {8}/ into a \t. In fact, people should not even
assume a tab is 8 when writing code. Instead,

\t	while (foo) {
\t	\t	bar = some_function_with_lots_of_args(par1, par2, par3,
\t	\t	\x20+ par4, par5, par6);
\t	}

\t should be used for "leading indent" only. Too bad almost noone cares.



	Jan
-- 
