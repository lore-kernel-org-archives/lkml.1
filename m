Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbXGJGPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbXGJGPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 02:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXGJGP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 02:15:28 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:35093 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbXGJGP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 02:15:27 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: Documentation of kernel messages (Summary)
Date: Tue, 10 Jul 2007 08:15:14 +0200
User-Agent: KMail/1.9.7
Cc: "Kunai, Takashi" <kunai@linux-foundation.jp>, holzheu@linux.vnet.ibm.com,
       "Rob Landley" <rob@landley.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, gh@us.ibm.com,
       arjan@infradead.org, sam@ravnborg.org, jengelh@computergmbh.de,
       hpa@zytor.com, joe@perches.com, auke-jan.h.kok@intel.com,
       hansendc@us.ibm.com, davem@davemloft.net, Valdis.Kletnieks@vt.edu,
       kenistoj@us.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
References: <1181747217.29512.9.camel@localhost.localdomain> <200707090901.47900.oliver@neukum.org> <a781481a0707091559x7103fea6vc74c06f451e66d55@mail.gmail.com>
In-Reply-To: <a781481a0707091559x7103fea6vc74c06f451e66d55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707100815.15619.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 10. Juli 2007 schrieb Satyam Sharma:
> But, I'm not sure they'd be operating against a known target -- I don't
> really know what exactly would be hashed, but if it's kernel printk()
> messages (the format string, obviously), then please remember that
> new messages would get added all the time, and unless we're also
> willing to change the hash function every time a printk() gets added
> to the kernel (whew!) it's going to be a problem -- especially because
> we don't really want to generate new hash functions for every kernel
> version / or for every kernel build, because we'd obviously like the
> same error message to hash to the same value across versions.

I suggest exactly that you build a new hash function for every build.
Nothing but your translating demon need ever see it. We build a new
System.map every time and it doesn't hurt.

	Regards
		Oliver

