Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYG1TIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYG1TIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYG1TI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:08:27 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:53417 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751863AbYG1TI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:08:26 -0400
Date: Tue, 29 Jul 2008 04:07:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] filldir write data missing size
Message-ID: <20080728190749.GA20019@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <87k5fi4l49.wl%ysato@users.sourceforge.jp> <871w1pn5wz.fsf@devron.myhome.or.jp> <87iqv1wwy1.wl%ysato@users.sourceforge.jp> <87r69pk51q.fsf@devron.myhome.or.jp> <87abgbgrvt.wl%ysato@users.sourceforge.jp> <878wvu9b6n.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wvu9b6n.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 06:31:12AM +0900, OGAWA Hirofumi wrote:
> Yoshinori Sato <ysato@users.sourceforge.jp> writes:
> 
> > This problem is sh-linux-gcc v4.1.2 and target sh2(a)-bigendian.
> >
> > "__put_user(s64, u32_ptr)" compiled.
> >
> > Correct code.
> > *u32_ptr = s64 & 0xffffffff;
> >
> > Bad code.
> > *u32_ptr = s64 >> 32;
> >
> > I'm add cast put_user 4byte case.
> 
> I see. How about the following patch? I guess the problems of this type
> should be fixed.
> 
I merged a different workaround as no one bothered to CC me on this
thread. Your fix looks more correct though, please provide a
Signed-off-by for it and I'll take this over the previous workaround.
