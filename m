Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0BNTeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 14:34:13 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44781 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab0BNTeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 14:34:11 -0500
X-Sasl-enc: t2G3ZwlWeG+QgKgquabboKOdmdzSD9fWL0cVbfkxlFsK 1266176049
Date: Sun, 14 Feb 2010 17:34:06 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Evans <mjevans1983@gmail.com>
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100214193406.GA15722@khazad-dum.debian.net>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Feb 2010, Michael Evans wrote:
> I remember hearing that 1.x had /no/ plans for kernel level
> auto-detection ever.  That can be accomplished in early-userspace
> leaving the code in the kernel much less complex, and therefore far
> more reliable.

Yes, it is far more reliable kernel side, if only because it doesn't do
anything.

But the userspace reliability is _not_ good.  initrds are a source of
problems the moment things start to go wrong, and that's when they are not
the problem themselves.

And the end result is a system that needs manual intervention to get its
root filesystem back.

In my experience, every time we moved critical codepaths to userspace, we
ended up decreasing the *overall* system reliability.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
