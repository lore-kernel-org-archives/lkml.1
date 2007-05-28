Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbXE1MK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbXE1MK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 08:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXE1MKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 08:10:20 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1392 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbXE1MKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 08:10:19 -0400
Message-ID: <465AC6AE.1060401@shadowen.org>
Date: Mon, 28 May 2007 13:10:22 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <20070527171817.4ce9d40d.akpm@linux-foundation.org>
In-Reply-To: <20070527171817.4ce9d40d.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 27 May 2007 18:11:25 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> 
>> +#gotos aren't indented
>> +		if($line=~/^\s*[A-Za-z\d_]+:/ and !($line=~/^\s*default:/)){
>> +			print "Gotos should not be indented\n";
>> +			print "$herecurr";
>> +			$clean = 0;
>> +		}
> 
> This should be "labels".  Plus a lot of people do indent the labels by
> a single space to avoid confusing `diff -p', which seems a reasonable
> thing to not complain about.

Yep makes sense.  Done.

-apw
