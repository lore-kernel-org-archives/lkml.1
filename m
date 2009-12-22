Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbZLVATP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbZLVATP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZLVATO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:19:14 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48267 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZLVATN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:19:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.33-rc1 build failure: copy_from_user() buffer size is not provably correct
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Ritesh Raj Sarraf <rrs@researchut.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4B2FADC5.3020709@zytor.com>
References: <20091221091330.GA22867@elte.hu> <4B2FADC5.3020709@zytor.com>
Message-Id: <20091222091642.1416.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 22 Dec 2009 09:19:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/21/2009 01:13 AM, Ingo Molnar wrote:
> > 
> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> >>>                  from mm/migrate.c:15:
> >>> In function ???copy_from_user???,
> >>>     inlined from ???do_pages_stat??? at mm/migrate.c:1009:
> >>> /tmp/all-yes-config/2.6.33-rc1/arch/x86/include/asm/uaccess_32.h:213: error: 
> >>> call to ???copy_from_user_overflow??? declared with attribute error: 
> >>> copy_from_user() buffer size is not provably correct
> >>
> >> afaik, ingo already queued this fix.
> >> please wait (very) few days.
> >>
> >> thanks.
> > 
> > hm, the one mm/migrate.c fix we had is already in -rc1:
> > 
> >  b9255850: mm: Adjust do_pages_stat() so gcc can see copy_from_user() is safe
> > 
> > I've Cc:-ed more folks.
> > 
> 
> That *is* the error report that he is describing.  What version of gcc
> is he using?  It might be dumber than the one I have.

I was also successed build.

my environment is here:

	2.6.33-rc1
	CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y
	gcc version 4.4.2 20091027 (Red Hat 4.4.2-7) (GCC)

I'm amazing (?_?)



