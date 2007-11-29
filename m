Return-Path: <linux-kernel-owner+w=401wt.eu-S1762619AbXK2KWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762619AbXK2KWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762529AbXK2KW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:22:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762490AbXK2KW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:22:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Thu, 29 Nov 2007 11:21:58 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       rusty@rustcorp.com.au
References: <20071122343.446909000@suse.de> <200711291055.02056.arnd@arndb.de> <200711291100.46598.ak@suse.de>
In-Reply-To: <200711291100.46598.ak@suse.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711291122.00324.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/6CJXO+yq+1oykei1p+uGmkf2TyrZlqaqLRDX
 eyR/pD67pHpVfHaR7W5alH1Q22T43owF9kuLjcoMwSqOazllf8
 jjORHLuEKqUWNnQeJEjAQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 November 2007, Andi Kleen wrote:
> > I think it would be good if you could specify a default namespace
> > per module, that could reduce the amount of necessary changes significantly.
> 
> But also give less documentation. It's also not that difficult to mark
> the exports once. I've forward ported such patches over a few kernels
> and didn't run into significant me

Part of your sentence seems to be missing, but I guess I understand your
point. How many files did you annotate this way? I can see it as being
useful to have the namespace explicit in each symbol, but doing it once
per module sounds like the 80% solution for 20% of the work, and the
two don't even conflict. In the current kernel, I count 12644 exported
symbols in 1646 files, in 540 directories.

One problem I can see with annotating every symbol is that it conflicts
with other patches that add more exported functions to a file without
adding the namespace, or that simply break because of context changes.

	Arnd <><
