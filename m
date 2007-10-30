Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbXJ3Mra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbXJ3Mra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 08:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbXJ3MrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 08:47:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42034 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXJ3MrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 08:47:22 -0400
Subject: Re: [PATCH 0/4] Unexport several headers and cleanup
From: David Woodhouse <dwmw2@infradead.org>
To: "Kirill A. Shutemov" <k.shutemov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1193742139-29738-1-git-send-email-k.shutemov@gmail.com>
References: <1193742139-29738-1-git-send-email-k.shutemov@gmail.com>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 08:47:37 -0400
Message-Id: <1193748457.2915.163.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 13:02 +0200, Kirill A. Shutemov wrote:
> This series of patches unexport several unneeded(I guess) headers from 
> userspace. Patches based on patch posted to linux-kernel@ by Mike Frysinger
> in July.

Looks OK to me, in general. How much userspace have you tested building
with this? Does it include stuff like gdb?

Not that I necessarily care about the answer in the normal way -- it's
just that if userspace will need to adapt, I'd like to get them moving
ASAP. One option for easing that might be to export stuff like page.h
but _empty_.

-- 
dwmw2

