Return-Path: <linux-kernel-owner+w=401wt.eu-S1030986AbXD1Fso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030986AbXD1Fso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030993AbXD1Fso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:48:44 -0400
Received: from web32412.mail.mud.yahoo.com ([68.142.207.205]:46279 "HELO
	web32412.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030986AbXD1Fsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:48:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=bDSPwq5Xtkb89zWqYMS6JD0i/xqk3lj2mzAmU7iC6+LNpQNND8AGWWhzUBS926+DleXdREjQXyJoG6HQKpL3UNOrY+wHkiEx1W9+qaeu3lLwFmfoRVUdb/qLlsELw590TApnCOfPPiv17hMjZRRFLLf/z90u/ZxcN9mBz/0vn+0=;
X-YMail-OSG: nKTdlqYVM1lkO99qFBzhCF0S50Orje8w_gEgNzasoBZSrDAu8bXKQoj2OGSEZApLZ.W9BGVQqc_XXhASA3OlcUtNv0RxKsCtwQB_pJ.CPhXex8TTqQXB_p1kIw--
Date: Fri, 27 Apr 2007 22:48:42 -0700 (PDT)
From: Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: [PATCH] Allow __vmalloc with GFP_ATOMIC
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pgiri@yahoo.com
In-Reply-To: <4632CA04.6040706@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <730052.85710.qm@web32412.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Nick Piggin <nickpiggin@yahoo.com.au> wrote:

>> The patch below uses bh disabled lock for vmlist_lock, so
>> that __vmalloc can be used in interrupt context.

> Hi Giri,
> 
> I'm sure I've read the reason for this one before, but when you do patches
> like these, can you include that reason in the changelog please?
> 
> Thanks,
> Nick

Sorry about that. There were too many mails on this subjet and thought it
might not be good to quote them. I am quoting here the ones that matter to
this discussion. If you need more (all), let me know:

http://www.ussg.iu.edu/hypermail/linux/kernel/0605.2/1608.html
http://www.ussg.iu.edu/hypermail/linux/kernel/0605.2/1611.html
http://www.ussg.iu.edu/hypermail/linux/kernel/0605.2/1656.html
http://www.ussg.iu.edu/hypermail/linux/kernel/0605.2/1779.html
http://www.ussg.iu.edu/hypermail/linux/kernel/0605.2/1669.html

Thanks,
Giri

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
