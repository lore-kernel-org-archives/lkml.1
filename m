Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbZJEURX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbZJEURX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZJEURX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:17:23 -0400
Received: from mail-yw0-f137.google.com ([209.85.211.137]:51369 "EHLO
	mail-yw0-f137.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbZJEURW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:17:22 -0400
MIME-Version: 1.0
Date: Mon, 5 Oct 2009 13:05:07 -0700 (PDT)
In-Reply-To: <drYiu-Pj-15@gated-at.bofh.it>
X-IP: 137.222.114.243
References: <drYiu-Pj-15@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) 
	Gecko/20090924 Ubuntu/9.10 (karmic) Firefox/3.5.3,gzip(gfe),gzip(gfe)
Message-ID: <f27af2f9-aabb-4627-8d11-b3c1296824c2@o21g2000vbl.googlegroups.com>
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 5, 5:10 pm, Jeff Chua <jeff.chua.li...@gmail.com> wrote:
> I've 3 systems with 4GB, 16GB and 64GB all running 32bit with these set:
[snip]
> Question is ... is there anyway to increase "low mem" without resorting to
> migrating to 64bit? (Look... it only has 378MB total low mem vs 850MB on
> the 4GB system). I've oracle installed on the 64GB system and it keeps
> getting OOMs!

Whilst linux may be able to address all 64GB of memory (running 32 or
64-bit), every 32-bit process will be limited to ~3GB virtual address
space, which may be the limiting factor for your out-of-memory issue
with Oracle. The only solution is to run 64-bit Oracle, alas.

Daniel
--
Daniel J Blueman
