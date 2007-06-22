Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbXFVRns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbXFVRns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbXFVRnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:43:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64959 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbXFVRnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:43:40 -0400
From: Malte Cornils <malte@cornils.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PROBLEM: PCI setup hangs on Asus Notebook (nolapic helps)
Date: Fri, 22 Jun 2007 19:43:34 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200706141505.27380.malte@cornils.net> <20070621052741.a44dc7f2.akpm@linux-foundation.org>
In-Reply-To: <20070621052741.a44dc7f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706221943.35517.malte@cornils.net>
X-Provags-ID: V01U2FsdGVkX19yFczjonTx7iVt0/xNIMyfFO9ImQbihleXRAu
 VI2LVGgT/0qDKEhhZam3xRnY3t0hTWEbV17J3TkZo8SZ6fq57T
 2PLyH3JK/22gssvCVbYWQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Thursday, 21. Juni 2007 14:27 Andrew Morton wrote:
> > Booting with nolapic helps, but makes the SATAized IDE controller buggy
> > [...] There have been other reports of the problem on Asus notebooks. I've
> > collected some links:[...]

> Are any of these problems new behaviour, or has it always done this?
>
> If there _is_ new behaviour here, are you able to identify which earlier
> kernel versions did not exhibit it?

The patch causing that behaviour went in between 2.6.18 and 2.6.19rc-1. I have 
some 100 patches to go bisecting the bug, but it's slow work due to 
difficulties in getting physical access to the machine for extended periods 
of time.

I'll be sure to let you know when I have the exact commit. That may be at any 
time from tomorrow to beginning of July, I'm not sure yet what my free time 
allows.

Yours,
-Malte
