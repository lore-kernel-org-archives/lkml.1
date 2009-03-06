Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZCFLNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZCFLNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZCFLNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:13:23 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:62449 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZCFLNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:13:22 -0500
Date: Fri, 06 Mar 2009 20:13:19 +0900 (JST)
Message-Id: <20090306.201319.95063735.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: thierry.reding@avionic-design.de, haavard.skinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dmaengine: Fix oops on dmatest module unload.
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <e9c3a7c20903041503lb2f55fct3ec39f268e609317@mail.gmail.com>
References: <1234441811-9628-1-git-send-email-thierry.reding@avionic-design.de>
	<e9c3a7c20902121612q724d0931ifb70d559081f206d@mail.gmail.com>
	<e9c3a7c20903041503lb2f55fct3ec39f268e609317@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009 16:03:47 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> ...and now it is unapplied :-).  The problem with this patch is that
> it releases the channel before dmatest is done with it.  'Cleanup'
> followed by 'release' is the right order, just need to save ->chan
> before it gets freed.

Oh that's right.  I tested your fix in async_tx tree and it works
fine.  Thanks!

---
Atsushi Nemoto
