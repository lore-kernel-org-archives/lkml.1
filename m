Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbYJKBRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbYJKBRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 21:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYJKBRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 21:17:33 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:31177 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbYJKBRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 21:17:33 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Prevent modpost from looking for a .cmd file for a static library linked into a module
Date: Fri, 10 Oct 2008 18:15:01 -0700
Message-ID: <8A71B368A89016469F72CD08050AD3340397130C@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Prevent modpost from looking for a .cmd file for a static library linked into a module
Thread-Index: AckrLDcbucN7lcEtQUerZ9ZFN91cyAAEJpeA
References: <8A71B368A89016469F72CD08050AD334038D52CF@maui.asicdesigners.com> <20081010160129.1159a2ef.akpm@linux-foundation.org>
From: "Ashutosh Naik" <ashutosh@chelsio.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <stable@kernel.org>,
       <rusty@rustcorp.com.au>, "Karen Xie" <kxie@chelsio.com>,
       "Sam Ravnborg" <sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 7 Oct 2008 11:26:15 -0700
"Ashutosh Naik" <ashutosh@chelsio.com> wrote:

>> 
>> This patch prevents modpost to look for a .cmd file when a module is
>> linked with a static library
>> 
>> Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>

>What is the reason for this change?

>Presumably there is some user-observeable behaviour which it corrects? 
>What is it, and under what circumstances does it occur?

This fixes a Compile time Warning, whenever a static library is linked
into a kernel module. MODPOST tries to look for a ".<modulename>.cmd"
file to look for its dependencies, but that file doesn't exist or get
generated for static libraries. 


<snip>

>The patch was wordwrapped.  I fixed that and queued it for sending to
>Sam.  Please send me an updated, complete changelog, thanks.

Thanks for fixing the wordwrap.

Here is the changelog:
This fixes a Compile time Warning, whenever a static library is linked
into a kernel module. MODPOST tries to look for a ".<modulename>.cmd"
file to look for its dependencies, but that file doesn't  exist or get
generated for static libraries.

Many Thanks,
Ashutosh
