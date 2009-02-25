Return-Path: <linux-kernel-owner+w=401wt.eu-S1761946AbZBYVfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761946AbZBYVfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbZBYVez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:34:55 -0500
Received: from web39802.mail.mud.yahoo.com ([209.191.106.63]:21247 "HELO
	web39802.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757372AbZBYVey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:34:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=6hjRAEYqM31T40z1A7gIYAWlWKKb8jalOYNniR2kmzKNAjZ+hkRL3o6JJ7A3c8D11362HqMQJif8aXxxQvtKso6WI/Ne137pQOgxiSfn7DAiL6AFcSSALgfx0gDaPU8NLhdw7ijQ2s8unp5Xkz7QUA36dJ+omvDoNpH8qt99Foc=;
X-YMail-OSG: w7wO3L8VM1kjzOBQKNcLF8WitT71nNu59rU3nNp2qyLxvvEAsoYeDqonevYFbkIRsZPEbpktGuLLOzF_vQaXC.gl.oZTnJaPG8pWSinM1cL8O7_gxKdT.7uV2YurN7r45ItR4uMO_QmFK9m6fm1bykq74Mev4bVIw3dx7MCMaohRMTDKtC90KtfaqVVjMw--
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
Date: Wed, 25 Feb 2009 13:34:52 -0800 (PST)
From: Vinay Venkataraghavan <raghavanvinay@yahoo.com>
Subject: Page protection flags in linux on an x86 platform
To: linux kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <257438.40011.qm@web39802.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





Folks,

I am trying to port some PPC code to x86 based linux. My question is that I am need to create some page mappings using remap_pfn_range. In the code for the PPC,
the protection flags being specified are:

__pgprot(_PAGE_NO_CACHE | _PAGE_GUARDED);

But it looks like these do not exist when linux is compiled for the x86 architecture. 

What are the relevant protection flags to achieve the same for the x86 architecture. 

Thanks for any help.

- Vinay


      
