Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbXGIHCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbXGIHCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 03:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbXGIHCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 03:02:00 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:36363 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbXGIHB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 03:01:59 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Kunai, Takashi" <kunai@linux-foundation.jp>
Subject: Re: Documentation of kernel messages (Summary)
Date: Mon, 9 Jul 2007 09:01:46 +0200
User-Agent: KMail/1.9.7
Cc: holzheu@linux.vnet.ibm.com, Rob Landley <rob@landley.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.org, mtk-manpages@gmx.net,
       jack@suse.cz, randy.dunlap@oracle.com, gregkh@suse.de, pavel@ucw.cz,
       tim.bird@am.sony.com, gh@us.ibm.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, hpa@zytor.com,
       joe@perches.com, auke-jan.h.kok@intel.com, hansendc@us.ibm.com,
       davem@davemloft.net, Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
References: <1181747217.29512.9.camel@localhost.localdomain> <1182957079.6643.13.camel@localhost.localdomain> <4691C480.5010600@linux-foundation.jp>
In-Reply-To: <4691C480.5010600@linux-foundation.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707090901.47900.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 9. Juli 2007 schrieb Kunai, Takashi:
> (b)printk hashes and (c)Format strings. (a) seems difficult to get
> supports from kernel developers and (c) lacks uniqueness of each
> message. Though (b) also lacks uniqueness, adding component id and/or

We have generators for hash functions that guarantee unique results
for a set of inputs. They are even GPLed. As you are operating against
a known target, that should work.

	Regards
		Oliver
