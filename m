Return-Path: <linux-kernel-owner+w=401wt.eu-S936663AbXJSWz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936663AbXJSWz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761151AbXJSWzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:55:20 -0400
Received: from main.gmane.org ([80.91.229.2]:54128 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976AbXJSWzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:55:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Date: Fri, 19 Oct 2007 21:32:08 +0000 (UTC)
Message-ID: <ffb7oo$k26$1@ger.gmane.org>
References: <200710181551.24912.florian.fainelli@telecomint.eu>
	<20071018173828.159b15dd@ephemeral>
	<200710191401.56916.florian.fainelli@telecomint.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 163.181.251.103
User-Agent: pan 0.120 (Plate of Shrimp)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 14:01:56 +0200, Florian Fainelli wrote:

> Hi Andres,
> 
> Le jeudi 18 octobre 2007, Andres Salomon a écrit :
>> While I certainly would like to see a generic GPIO API, this one isn't
>> really useful for geode GPIOs.  It would be nice to have one that did
>> work for us as well.  Unfortunately, I haven't had the chance to give
>> much thought to this problem yet.
> 
> This one was discussed mostly on the ARM mailing-list and finally made his way 
> to the mainline kernel. Though it lacks some functions to change for instance 
> a entire GPIO line and not a single bit, it is used on ARM and MIPS systems 
> so I would conform with this one for now because it is used by at least two 
> or more architectures.

Its reasonable to expect that the API will expand over time as it is
thrust into new situations.  There is nothing wrong with the existing API,
it does an admirable job of simple GPIO frobbing.  But on the Geode, GPIOs
can do much more then just simple input and output.  We can cause events,
use input filtering for debouncing, set various drain options, and more.
And these are not bullet points from the datasheet that we want to
implement for completeness; these functions are actually being used right
now in the kernel on real hardware.  Just because other architectures
haven't found a need to expand the API doesn't mean that we shouldn't
expand it now.  And bear in mind, the Geode isn't unique - I'll bet beers
that there are MIPS and ARM architectures that have these features too,
and they would use the API if it existed.

Jordan

