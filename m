Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbZLURZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbZLURZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 12:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbZLURZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 12:25:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:48245 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbZLURZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:25:18 -0500
Date: Mon, 21 Dec 2009 18:27:10 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ritesh Raj Sarraf <rrs@researchut.com>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.33-rc1 build failure: copy_from_user() buffer size is not
 provably correct
Message-ID: <20091221182710.5bf364c1@infradead.org>
In-Reply-To: <4B2FADE2.200@zytor.com>
References: <0io307-9ti.ln1@news.researchut.com>
	<20091221180537.089C.A69D9226@jp.fujitsu.com>
	<20091221091330.GA22867@elte.hu>
	<200912211639.05887.rrs@researchut.com>
	<4B2FADE2.200@zytor.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009 09:18:26 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 12/21/2009 03:09 AM, Ritesh Raj Sarraf wrote:
> > 
> > I have verified the build tree and am building from -rc1 only. The
> > fix you've mentioned above is also part of it.
> > 
> > debian-build:/tmp/all-yes-config/2.6.33-rc1# cat Makefile |grep
> > EXTRAVERSION EXTRAVERSION = -rc1
> > 
> > Must be a newer bug then.
> > 
> 
> No, it's the same one, but different gcc.  Sigh.

worth trying the variant I had ;-)
