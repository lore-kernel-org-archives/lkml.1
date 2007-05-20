Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbXETTPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbXETTPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbXETTOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:14:55 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39238 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbXETTOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:14:55 -0400
Date: Sun, 20 May 2007 21:15:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Factor out common MODULE_INFO content from module*.h files.
Message-ID: <20070520191552.GA25200@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0705201502160.17519@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705201502160.17519@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 03:06:15PM -0400, Robert P. J. Day wrote:
> 
> In order to eventually break the interdependency between the module.h
> and moduleparam.h header files, factor out the common MODULE_INFO
> content into a new header file.

The moduleinfo.h file looks redundant at first look.
Why not push relevant parts from moduleparam.h (the
MODULE_INFO bits) to module.h and let go of
the include of moduleparam.h in module.h (when you
have fixed the users)?

In this way we do not add an extra .h file.
And files that needs moduleparam.h will anyway always need module.h.
But not the other way around.

	Sam
