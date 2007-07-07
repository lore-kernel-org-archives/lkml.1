Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbXGGWFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbXGGWFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 18:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXGGWFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 18:05:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:41520 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbXGGWFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 18:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KG59af2icdpLyrKdxw4t2mTdV6eYQUhAqCnFW65/e4Zl0emVMBbm2WLl3buKi3B8LKLUPpK5G3sHCXvecq3gVOkx0qhn+e+QbkDphzeWUOl+g9zl2eymIDrnmszwTby9kcxRbZqnVqQmVEugp5yoQ7hak65cmVY+47pJS0C0QE4=
Message-ID: <46900E24.7090406@gmail.com>
Date: Sun, 08 Jul 2007 00:05:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: yoann padioleau <padator@wanadoo.fr>
CC: akpm@linux-foundation.org, kernel-janitors@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kcalloc prototype [Was: + some-kmalloc-memset-kzalloc-tree-wide.patch
 added to -mm tree]
References: <200707062316.l66NGQXp026235@imap1.linux-foundation.org> <468F2A02.10402@gmail.com> <1CA436EC-008F-4FB1-8589-9276EA637F48@wanadoo.fr>
In-Reply-To: <1CA436EC-008F-4FB1-8589-9276EA637F48@wanadoo.fr>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

yoann padioleau napsal(a):
>> static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> 
> you are right, but why the type of kcalloc is not
> static inline void *kcalloc(int n, size_t size, gfp_t flags) ?

Maybe C89 calloc prototype...

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
