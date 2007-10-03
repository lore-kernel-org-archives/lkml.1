Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbXJCOkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbXJCOkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXJCOkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:40:13 -0400
Received: from namei.org ([69.55.235.186]:51962 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752277AbXJCOkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:40:11 -0400
Date: Wed, 3 Oct 2007 07:39:49 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
cc: penguin-kernel@I-love.SAKURA.ne.jp, a.p.zijlstra@chello.nl,
       kaigai@kaigai.gr.jp, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
In-Reply-To: <20071003.233249.126777093.yoshfuji@linux-ipv6.org>
Message-ID: <Xine.LNX.4.64.0710030739160.378@us.intercode.com.au>
References: <200710032259.HJF90663.OFMLOJtQHOFVSF@I-love.SAKURA.ne.jp>
 <1191420442.5599.12.camel@lappy> <200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp>
 <20071003.233249.126777093.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="927316971-1234522869-1191422389=:378"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--927316971-1234522869-1191422389=:378
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 3 Oct 2007, YOSHIFUJI Hideaki / µÈÆ£±ÑÌÀ wrote:

> In article <200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp> (at Wed, 3 Oct 2007 23:26:57 +0900), Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> says:
> 
> > Peter Zijlstra wrote:
> > > Also, how do you avoid referencing dead data with your sll? I haven't
> > > actually looked at your patches, but the simple scheme you outlined
> > > didn't handle the iteration + concurrent removal scenario:
> > Regarding my singly-linked list, no entries are removed from the list. It's append only (like CD-R media).
> > I set is_deleted flag of a entry instead of removing the entry from the list.
> 
> It is not a good practice.  Please free such objects.
> BTW, how many objects do you have in the list?

Doesn't matter.  No list should be able to grow without bounds in the 
kernel.

-- 
James Morris
<jmorris@namei.org>
--927316971-1234522869-1191422389=:378--
