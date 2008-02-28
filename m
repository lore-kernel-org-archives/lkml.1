Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbYB1TR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbYB1TR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbYB1TRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:17:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:53090 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbYB1TRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:17:49 -0500
Date: Thu, 28 Feb 2008 20:17:07 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: 7eggert@gmx.de, Davide Libenzi <davidel@xmailserver.org>,
       Pierre Habouzit <madcoder@debian.org>,
       lkml <linux-kernel@vger.kernel.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Marc Lehmann <schmorp@schmorp.de>,
       David Schwartz <davids@webmaster.com>
Subject: Re: epoll and shared fd's
In-Reply-To: <cfd18e0f0802280410wccefb42ja66a2f4ee7513183@mail.gmail.com>
Message-ID: <alpine.LSU.0.999.0802281942420.2968@be1.lrz>
References: <9MZLT-1YO-33@gated-at.bofh.it> <9N6Ng-5tn-21@gated-at.bofh.it>
  <9P5WE-33i-11@gated-at.bofh.it> <9Pk9l-1KA-1@gated-at.bofh.it> 
 <9PNNZ-b0-5@gated-at.bofh.it> <a19Lb-1F0-13@gated-at.bofh.it> 
 <a19Lb-1F0-11@gated-at.bofh.it>  <E1JU4Lu-0000mn-H2@be1.7eggert.dyndns.org>
 <cfd18e0f0802280410wccefb42ja66a2f4ee7513183@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/WqAxHMDX10BPlitFONApCFvTWWiwJcUoHpJL
 dps1ACuB+TgM2TVbY8GL5L9vGWbNa1RNV7xWmah3JVzPe1NPfG
 JQGi1R1W2IeZZmdKHu77w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Michael Kerrisk wrote:

> On Tue, Feb 26, 2008 at 7:16 PM, Bodo Eggert <7eggert@gmx.de> wrote:
> > Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
> >
> >  > b) It seems to me that you text doesn't quite make the point explicit
> >  > enough.  I've tried to rewrite it; could you please check:
> >  >
> >  >        A6     Yes, but be aware of the following point.  A  file
> >  >               descriptor is a reference to an open file descrip-
> >  >               tion (see  open(2)).   Whenever  a  descriptor  is
> >  >               duplicated  via dup(2), dup2(2), fcntl(2) F_DUPFD,
[.........]

> >  > Does that seem okay?  I plan to include the text in man-pages-2.79.
> >
> >  It's hard to read for me, and probably very hard to read for others.
> 
> Bodo,
> 
> I'm just reviewing this text, trying to see if I can improve it.  At
> the moment, I'm a little stuck.  can you say a little more about why
> you find it hard to read?  that may help me improve it.

I think it's enough to mention that the last copy of the file descriptor 
(e.g. by dup or fork) must be closed *or* the file must be explicitely 
unregistered (As far as I understand by now).
-- 
"Aim towards the Enemy."
-Instruction printed on US Rocket Launcher
