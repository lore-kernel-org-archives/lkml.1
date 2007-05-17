Return-Path: <linux-kernel-owner+w=401wt.eu-S1761722AbXEQUfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722AbXEQUfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbXEQUfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:35:12 -0400
Received: from main.gmane.org ([80.91.229.2]:56723 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbXEQUfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:35:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Date: Thu, 17 May 2007 20:30:30 +0000 (UTC)
Message-ID: <pan.2007.05.17.20.30.30@free.fr>
References: <20070517143200.GA30850@lst.de>
	<1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de>
	<1179414590.3642.69.camel@sauron>
	<20070517102931.6bbbad1a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: cac94-1-81-57-151-96.fbx.proxad.net
User-Agent: Pan/0.125 (Potzrebie)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 10:29:31 -0700, Andrew Morton wrote:

> On Thu, 17 May 2007 18:09:50 +0300 Artem Bityutskiy
> <dedekind@infradead.org> wrote:
> 
> umm..  I'd say what you've done in there is an improvement to the
> exiting stuff: getting gcc to check it is better than having to use
> sparse.
> 
> I'd have expected gcc to generate poorer code with your approach but I'm
> showing zero text size changes from Christoph's patch (gcc-4.1 and
> gcc-3.4.5).
> 
>
On which arch did you try ?
X86 where unaligned access are ok ?

On arch that don't support aligned access, packed struct access will be 
done byte per byte (but it could be the expected behavior if there 
unaligned access).

Matthieu

