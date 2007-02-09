Return-Path: <linux-kernel-owner+w=401wt.eu-S1946371AbXBILS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946371AbXBILS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946376AbXBILS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:18:56 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:14195 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946371AbXBILSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:18:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kbGbMMXfFWi1XvsDK1wx5iduxqPVEm/qneTtyPipczg4NtvVmeIIjsX5UXFQVgnhOnx36j1+sqHyTXCzaJ9SAj4/xoZ1lPe18rJ5QlekjoXJMzbp3Cu2QPGlL8wqu+8lu6daBLNugls42YCAm27wdFgOgqsur3MkRPOl0bADcMY=
Message-ID: <9a8748490702090318o3acd5ef1t2525afc9c3776e85@mail.gmail.com>
Date: Fri, 9 Feb 2007 12:18:53 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Pavel Pisa" <pisa@cmp.felk.cvut.cz>
Subject: Re: Coding style question
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, "Sascha Hauer" <s.hauer@pengutronix.de>,
       "Pierre Ossman" <drzeus@drzeus.cx>
In-Reply-To: <200702091132.09741.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702091132.09741.pisa@cmp.felk.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/07, Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
> Hello All,
>
> I have question if next style of macros definitions
> for hardware registers is acceptable (tastefull for
> maintainers) for Linux kernel.
>

It is generally preferred to keep macro names all uppercase.
Also, when possible, static inline functions are preferred over macros.

[...snip...]
> found in each source file. If you prefer some already
> utilized style, direct me to right examples, please.
>
Documentation/CodingStyle : Chapter 12: Macros, Enums and RTL

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
