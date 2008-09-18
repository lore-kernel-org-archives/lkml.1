Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYIREzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYIREzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 00:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYIREzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 00:55:38 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34408 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbYIREzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 00:55:37 -0400
Message-ID: <48D1DF43.4090804@davidnewall.com>
Date: Thu, 18 Sep 2008 14:25:31 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Halesh S <halesh.s@india.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: execve exit status on MIPS
References: <loom.20080918T041321-307@post.gmane.org>
In-Reply-To: <loom.20080918T041321-307@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Halesh S wrote:
> char e2BIG[ARG_MAX+1][10];
> ...
>   for(ind = 0; ind < ARG_MAX+1; ind++)
>     strcpy(e2BIG[ind], "helloworld");
>   

Did you intend to overflow e2BIG?  You're copying 11 bytes (including
terminating NUL) into a 10 byte array.
