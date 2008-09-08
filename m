Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbYIHTUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbYIHTUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYIHTUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:20:44 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:42174 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYIHTUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:20:44 -0400
Message-ID: <48C57B07.6000701@grupopie.com>
Date: Mon, 08 Sep 2008 20:20:39 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] exclude h8300 local symbols (Re: kallsyms exclude local
 symbols)
References: <87fxphzan5.wl%ysato@users.sourceforge.jp>	<489AE3C5.2000807@grupopie.com>	<87zlnotn2l.wl%ysato@users.sourceforge.jp> <20080907235627.293b0a4b.akpm@linux-foundation.org>
In-Reply-To: <20080907235627.293b0a4b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> This patch broke kallsyms on powerpc.  Please see
> http://ozlabs.org/pipermail/linuxppc-dev/2008-September/062549.html

I've just looked at that post and it seems that there are a lot of 
regular symbols that start with '.' on powerpc (see: 
http://userweb.kernel.org/~akpm/nm-n.txt ).

I guess the best solution would be to change the patch to use that 
filter only when the target architecture is h8300, so that it doesn't 
mess with other architectures.

-- 
Paulo Marques - www.grupopie.com

"To be, or not to be? That is ..... liable to be removed at -O2 and above."
