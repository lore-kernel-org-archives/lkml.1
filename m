Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbXHUPLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbXHUPLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 11:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760737AbXHUPLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 11:11:42 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4263 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760731AbXHUPLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 11:11:41 -0400
Date: Tue, 21 Aug 2007 17:12:10 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Marco Costalba <mcostalba@gmail.com>
cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH] qconf: show red links for disabled options
In-Reply-To: <e5bfff550708180706n48e67d24qc74847ea4462c149@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708211415340.1817@scrub.home>
References: <e5bfff550708180706n48e67d24qc74847ea4462c149@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 18 Aug 2007, Marco Costalba wrote:

> When 'Show debug info' is checked then a list of links
> to dependant symbols is shown in info view right bottom pane.
> 
> Currently all links are in standard blue. With this patch
> links to disabled symbols are shown in red instead.

The way you currently define "disabled" means that even symbols set to 'm' 
are disabled, I don't think that's what you really mean. :) When seeing 
disabled I also first thought of the option being completely invisible due 
to dependencies.

> This, together with 'Show all options', allows to quickly
> check out why a given option is hidden.

Dependencies can also be something like !FOO, in this case you want FOO to 
be disabled for option to be unhidden. So if this is intended as a simple 
"Click this link to enable this option", then this requires a bit more 
work. :)

> I understand that color coding could be a poor choice due to people
> with color differencing problems.
> 
> I chose this anyway to avoid crufting the output with additional signs/symbols,
> this could became very ugly in case of long option lists.

Using colors is not the problem, I'm more concerned about using red, as 
it's a signal color, often meaning that something is wrong or needs urgent 
attention.

bye, Roman
