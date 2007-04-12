Return-Path: <linux-kernel-owner+w=401wt.eu-S1030522AbXDLRQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030522AbXDLRQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030532AbXDLRQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:16:12 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:35072 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030522AbXDLRQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:16:11 -0400
Date: Thu, 12 Apr 2007 19:16:06 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070412171606.GA24756@uhulinux.hu>
References: <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com> <20070412091120.GA15666@uhulinux.hu> <461E5212.8070807@zytor.com> <Pine.LNX.4.61.0704121840350.14441@yvahk01.tjqt.qr> <20070412165540.GB21576@uhulinux.hu> <461E653E.6020400@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <461E653E.6020400@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 09:58:38AM -0700, H. Peter Anvin wrote:

> Not leaving dead code in the kernel is long-standing policy; it's 
> nothing new.  We constantly remove #if 0'd code that the authors have 
> left in.

I see. However, you wrote it recently:

> Besides, would it not make more sense to have a single table with the
> width information, if you insist on having one, instead of multiple ones?

If I rework the code according to this then the zero-width information will
no longer be dead code, right? The unchanged kernel would be slightly larger
and would run slightly slower, but it would be much easier to patch it to
reach the other possible behavior regarding combining characters.



-- 
Egmont
