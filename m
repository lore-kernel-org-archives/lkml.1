Return-Path: <linux-kernel-owner+w=401wt.eu-S966856AbXEGUyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966856AbXEGUyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966590AbXEGUyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:54:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34886 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966598AbXEGUyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:54:46 -0400
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
	points about ...)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org,
       Johannes Stezenbach <js@linuxtv.org>
In-Reply-To: <463CD106.3000706@gmail.com>
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	 <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net>
	 <4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net>
	 <4639F554.1040505@gmail.com> <20070503153129.268110@gmx.net>
	 <463A0462.5070106@gmail.com>
	 <d9def9db0705030859y66b1ef8fv22fc844c77bcc3c6@mail.gmail.com>
	 <463A0B36.5080204@gmail.com>
	 <d9def9db0705031019l5083d1c1h607b0829ab526f1@mail.gmail.com>
	 <1178215045.12651.124.camel@localhost>  <463A31EE.20907@gmail.com>
	 <1178388401.12541.115.camel@localhost>  <463CD106.3000706@gmail.com>
Content-Type: text/plain
Date: Mon, 07 May 2007 17:54:29 -0300
Message-Id: <1178571269.18383.296.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manu,

> From my side, quite some time has been put forward to write that mail.
> Inspite of that if you feel that you do have to go your own way, then
> it is completely upto you. I would say: do as you feel in such a case.

The point is that those issues are pending for a long time, and they
should be solved, especially the module removal issue (*)

If you are so afraid about applying those changes, maybe the better is
to apply those patches at v4l-dvb tree and at -mm, asking people to
test.

We may hold their commit on kernel mainstream until the next kernel
release, if nobody complains about, or otherwise revert the changes, if
they proofed to cause troubles at dst and/or dvb-bt8xx.

Also, you (or others) may write another approach keeping the fixes with
an strategy more adequate for dst.

Do you agree with this way?

-- 
Cheers,
Mauro

(*) Currently, dst can be removed only with "rmmod -f", due to a wrong
usage count. With Trent's patches, this were fixed.

