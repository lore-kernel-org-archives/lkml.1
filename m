Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbZKXI4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbZKXI4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932277AbZKXI4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:56:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51010 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbZKXI4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:56:12 -0500
Date: Tue, 24 Nov 2009 17:55:44 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: holzheu@linux.vnet.ibm.com
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1258981499.11269.6.camel@holzheu-laptop>
References: <2f11576a0911031158r7fabb96fx8073bb4e86f4981e@mail.gmail.com> <1258981499.11269.6.camel@holzheu-laptop>
Message-Id: <20091124175338.AFB6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> I have several places in my code where the new __must_check of strstrip
> will introduce unnecessary dummy variables to avoid the warnings.
> 
> Therefore I would like to have the suggested new strim() or
> strstip_tail() function. Any chance to have this upstream soon?

strim() is in mmotm now. I expect it will merge mainline soon.

Thanks.


> 
> Michael
> 
> On Wed, 2009-11-04 at 04:58 +0900, KOSAKI Motohiro wrote:
> > 2009/11/4 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > >> static inline void strsrip_tail(char *str)
> > >> {
> > >>       char *x __used;
> > >>       x = strstrip(str);
> > >> }
> > >
> > > Bikeshed time but its cleaner to do
> > >
> > > static inline __must_check void strstrip(char *str)
> > > {
> > >        return strim(str);
> > > }
> > >
> > > and make strim() the old strstrip function without the check requirement
> > 
> > Okey...
> > 
> > [quick hack and compile check]
> > 
> > done :)
> > sorry for attached file. I'm under poor mail environment now.
> 



