Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0CEJzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:55:31 -0500
Received: from lilzmailso01.liwest.at ([212.33.55.23]:49947 "EHLO
	lilzmailso02.liwest.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752845Ab0CEJza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:55:30 -0500
Message-ID: <4B90C974.2050405@viscovery.net>
Date: Fri, 05 Mar 2010 10:05:56 +0100
From: Johannes Sixt <j.sixt@viscovery.net>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: gitignore broken in git 1.7.0.1: slash checks leading dirs
References: <4B90C701.3070308@gmail.com>
In-Reply-To: <4B90C701.3070308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby schrieb:
> having 'linux' line in .gitignore makes 'include/linux/vga_switcheroo.h'
> to be ignored

That's the behavior that I would expect.

> though the documentation says:
> ***
> If the pattern does not contain a slash /, git treats it as a shell
> glob pattern and checks for a match against the pathname without
> leading directories.
> ***

and this citation confirms my expectation. Note that it says "pathname",
not "filename". 'include/linux' is a "pathname".

-- Hannes

