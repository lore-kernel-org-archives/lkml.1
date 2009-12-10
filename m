Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbZLJQrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbZLJQrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761123AbZLJQri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:47:38 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:34491 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761102AbZLJQri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:47:38 -0500
Message-ID: <4B21262E.4020503@hp.com>
Date: Thu, 10 Dec 2009 11:47:42 -0500
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dan Carpenter <error27@gmail.com>,
       Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Documentation/email-clients.txt: clarify Thunderbird
 section
References: <4B210C6C.3060103@tuffmail.co.uk> <4B2110E3.8010508@hp.com> <4B2120F2.3090301@tuffmail.co.uk>
In-Reply-To: <4B2120F2.3090301@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> /google
> 
> The RFC for format=flowed says that it should escape lines which start
> with a space (by "space stuffing" - prepending an additional space).  So
> in theory it should completely break patches.   And indeed it does
> <http://gcc.gnu.org/ml/java-patches/2003-q2/msg00315.html>
> 
> Using HTML preformat in current versions of Thunderbird appears to send
> with a format=flowed content-type, and then violates the RFC by not
> performing any space-stuffing.
> 
> So if I look at format=flowed patch in my Sent email folder, I see that
> the message viewer correctly strips the first leading space in each
> line.  I.e. it breaks if you use copy+paste to get the patch out of
> Thunderbird (or any other format=flowed aware client).  File->Save As
> preserves the spaces though, allowing the patch to be applied.
> 
> Regards
> Alan "Don't you feel better knowing that"

Thanks, yes I do...

Since the text wrap=0 also shut off "space stuffing" on send
in my version (as seen by the raw message on my smtp gateway),
I'm thinking they have html/text consistent sending bugs.

So I'll use the "format=flowed,false" in my prefs so
they don't blow me away with a future fix :)

jim
 
