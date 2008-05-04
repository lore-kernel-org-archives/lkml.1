Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYEDT2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYEDT2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYEDT2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:28:09 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:47070 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbYEDT2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:28:08 -0400
Message-ID: <481E0E76.3060900@gmail.com>
Date: Sun, 04 May 2008 21:28:54 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - a suggestion how to fix the select issue
References: <20080504071041.GA15315@uranus.ravnborg.org>
In-Reply-To: <20080504071041.GA15315@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.5 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-05-08 09:10, Sam Ravnborg wrote:

> Today we have two ways to express/solve dependencies.
> 
> Top-down we have "depends on"
> and bottom up we have "select".
> 
> The "depends on" dependencies at the same
> time impact the visibility of a symbol.
> A symbol with "depends on" not satisfied are not
> visible and thus not shown in menuconfig.

I've always really disliked the visibility thing. I believe it's not really 
the core issue here but regardless of anything else, could we not "grey out" 
non-selectable options with its helpt text still available? That's much more 
the standard UI paradigm.

Rene.
