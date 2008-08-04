Return-Path: <linux-kernel-owner+w=401wt.eu-S1761267AbYHDGtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267AbYHDGtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbYHDGt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:49:26 -0400
Received: from smtp6-g19.free.fr ([212.27.42.36]:58901 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760773AbYHDGtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:49:25 -0400
Message-ID: <4896A672.2050400@free.fr>
Date: Mon, 04 Aug 2008 08:49:22 +0200
From: Albert ARIBAUD <albert.aribaud@free.fr>
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: rae l <crquan@gmail.com>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cscope-devel@lists.sourceforge.net
Subject: Re: some problems with latest cscope-15.6, the better way to generate
 cscope database change
References: <91b13c310808031851v2ca9923fuf543eb4fe9c92e2b@mail.gmail.com>
In-Reply-To: <91b13c310808031851v2ca9923fuf543eb4fe9c92e2b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rae l a écrit :
> From: Denis ChengRq <crquan@gmail.com>
> 
> It's a problem about cscope target of kernel Makefile, and the cscope
> plugin of emacs:
> 1. `make cscope` will generate cscope.files cscope.{in,po,}.out;
> 2. the cscope plugin expect a cscope.out.{in,po,};
> 3. the default `cscope -b` would generate cscope.{in,po,}.out;
> 
> There are three approach to solve it:
> 1. modify the cscope C code;
> 2. modify the cscope emacs plugin lisp code;
> 3. modify the Makefile;
> 
> I have tried to communicate with the cscope upstream, but later I
> realize the third approach is most meaningful.

Er... If the plugin differs from the 'original' code, then I would tend to 
think that the plugin must be fixed, mustn't it? Because there might be 
other apps out there apart from the makefile and plugin which use 
cscope.po.out rather than cscope.out.po, so changing cscope would break 
lots of things. And changing the Makefile will make it only work with the 
plugin but would break other cscope-related apps.

Amicalement,
-- 
Albert.
