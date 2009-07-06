Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbZGFIYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbZGFIYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZGFIYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:24:43 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:35980 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbZGFIYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:24:43 -0400
Date: Mon, 6 Jul 2009 09:23:18 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Shinya Kuribayashi <shinya.kuribayashi@necel.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       skuribay@ruby.dti.ne.jp, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Trivial: Fix filenames in their headers for the
	EMMA Mark-eins.
Message-ID: <20090706082318.GA30667@linux-mips.org>
References: <1246746621-10320-1-git-send-email-cascardo@holoscopio.com> <20090705223051.GA18858@linux-mips.org> <4A514177.4000505@necel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A514177.4000505@necel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 09:12:39AM +0900, Shinya Kuribayashi wrote:

> How about arch/mips/fw/lib/call_o32.S?

Thanks, I missed that.  I only changed the files Thadeu found and the
files "git-ls-files | while read i; do fgrep -l $i $i; done" found.  So
I may have missed a few files.

> Btw, let's have extable.c have, at least, a copyright later.

A copyright header isn't stricly required - but I added one anyway based
on the information I found in "git log arch/mips/mm/extable.c".

> Acked-by: Shinya Kuribayashi <shinya.kuribayashi@necel.com>

Applied.

  Ralf
