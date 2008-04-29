Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbYD2S3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbYD2S3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755768AbYD2S2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:28:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148AbYD2S2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:28:53 -0400
Date: Tue, 29 Apr 2008 11:28:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] vt: fix background color on line feed
Message-Id: <20080429112810.4d11a21d.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.1.10.0804292014130.21466@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804270257270.20150@fbirervta.pbzchgretzou.qr>
	<20080427193616.9a9cdf85.akpm@linux-foundation.org>
	<alpine.LNX.1.10.0804280835370.20150@fbirervta.pbzchgretzou.qr>
	<alpine.LNX.1.10.0804292014130.21466@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 20:17:26 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> On Monday 2008-04-28 08:46, Jan Engelhardt wrote:
> >On Monday 2008-04-28 04:36, Andrew Morton wrote:
> >>> commit c5180a555ced08a7e3011c16ef796e47569ae907
> >>> Author: Jan Engelhardt <jengelh@computergmbh.de>
> >>> Date:   Thu Apr 24 22:40:24 2008 +0200
> >>> 
> >>> vt: fix background color on line feed
> >>>     
> >>> A command that causes a line feed while a background color is active,
> >>> such as
> >>>     
> >>> 	perl -e 'print "x" x 60, "\e[44m", "x" x 40, "\e[0m\n"'
> >>> and
> >>> 	perl -e 'print "x" x 40, "\e[44m\n", "x" x 40, "\e[0m\n"'
> >>>     
> >>> causes the line that was started as a result of the line feed to be
> >>> completely filled with the currently active background color instead
> >>> of the default color.
> >>
> >>Thanks.
> >>
> >>It would be better if the the changelog were to also describe the cause of
> >>the bug, and how the patch fixes it.
> >>
> >Please append:
> >[...]
> 
> I think your mailer has whitespace problems -- all whitespaces
> got replaced by two,

That's the default (ie: only ;)) behaviour of my editor's
reformat-paragraph command.

> even intrasentence after an "e.g."  :-P

Perhaps I should fix that.  Only I wrote it, umm, 22 years ago and forget
how it works.

