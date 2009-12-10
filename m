Return-Path: <linux-kernel-owner+w=401wt.eu-S1761943AbZLJWQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761943AbZLJWQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761927AbZLJWQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:16:43 -0500
Received: from xenotime.net ([72.52.64.118]:50399 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761924AbZLJWQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:16:43 -0500
Date: Thu, 10 Dec 2009 14:16:48 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, jim owens <jowens@hp.com>,
       linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Dan Carpenter <error27@gmail.com>,
       Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Documentation/email-clients.txt: clarify Thunderbird
 section
Message-Id: <20091210141648.4b0483a6.rdunlap@xenotime.net>
In-Reply-To: <4B2170BB.2070001@nortel.com>
References: <4B210C6C.3060103@tuffmail.co.uk>
	<4B2110E3.8010508@hp.com>
	<4B2120F2.3090301@tuffmail.co.uk>
	<4B2170BB.2070001@nortel.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 16:05:47 -0600 Chris Friesen wrote:

> On 12/10/2009 10:25 AM, Alan Jenkins wrote:
> 
> > The RFC for format=flowed says that it should escape lines which start 
> > with a space (by "space stuffing" - prepending an additional space).  So 
> > in theory it should completely break patches.   And indeed it does 
> > <http://gcc.gnu.org/ml/java-patches/2003-q2/msg00315.html>
> > 
> > Using HTML preformat in current versions of Thunderbird appears to send 
> > with a format=flowed content-type, and then violates the RFC by not 
> > performing any space-stuffing.
> > 
> > So if I look at format=flowed patch in my Sent email folder, I see that 
> > the message viewer correctly strips the first leading space in each 
> > line.  I.e. it breaks if you use copy+paste to get the patch out of 
> > Thunderbird (or any other format=flowed aware client).  File->Save As 
> > preserves the spaces though, allowing the patch to be applied.
> 
> Hmm...I'm using Thunderbird 3 beta4, and it appears that when sending
> via the "preformat" mechanism it actually does perform space-stuffing.
> This is visible as an extra leading space when looking at the raw source
> of the sent (or received) email via ctrl-U.
> 
> However, if one turns off format=flowed, but leaves wrap set to 72, then
> the html preformat works without having to set the wrap to 0.

Surely this help text needs to be updated. It's most likely
a moving target (how thunderbird acts, that is), but anything that
helps is good.

---
~Randy
