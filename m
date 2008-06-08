Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbYFHU7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbYFHU7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbYFHU7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:59:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32856 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbYFHU67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:58:59 -0400
Subject: Re: [PATCH] Speed up "make headers_*"
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier@gentoo.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080608200727.GA32141@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org>
	 <20080608200727.GA32141@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 08 Jun 2008 21:58:54 +0100
Message-Id: <1212958734.2534.51.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't look like headers_check_all will work after your patches --
but to be fair I don't think it worked _before_ them either. When you
run headers_install_all, there's no asm/ directory -- and thus the check
will fail for any headers in linux/ which try to include <asm/*.h>. 

Did this _ever_ work?

-- 
dwmw2

