Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZLAQI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZLAQI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZLAQI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:08:57 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:42523 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbZLAQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=guDFgsVIZXzCCcbtgcnDCpaorPXt0gYl2yuV+AtrTmce597ymTBjZH2/yEJC7Zc/u4
         /ywTJYasWEO0R8E/R+bAnVWsT0FWBsPAIICB+6V63QxX70fPeRuuHBfylqyO9WUggcuC
         CZf+redEFn/ptpR0JoquyDit6BCdtudGDAOKU=
Message-ID: <4B153F9B.7050502@gmail.com>
Date: Tue, 01 Dec 2009 11:08:59 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: warning: massive change to conditional coding style in net?
References: <4B13A025.7000103@gmail.com> <1259603798.29779.293.camel@Joe-Laptop.home>
In-Reply-To: <1259603798.29779.293.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Mon, 2009-11-30 at 05:36 -0500, William Allen Simpson wrote:
>> Over the past several days, David Miller (with help from Joe Perches)
>> made sweeping changes to the format of conditional statements in the
>> net tree -- the equivalent of mass patches that change spaces.
>> This makes writing patches for multiple versions of the tree very
>> difficult, and will make future pullups problematic.
> 
> If it makes getting tcp cookies accepted difficult,
> a reversion is simple.  That style isn't as important.
> 
Then why make an *un*important (yet sweeping) change?


> I think writing a single set of patches for multiple
> versions of linux is not feasible.  Feature changes
> occur in kernel source daily.
> 
My patches were carefully written and applied with small fuzz to .30,
and .31, and .32-rc3.


>> 	if (condition
>> 	    && condition
>> 	    && (condition
>> 	        || condition
>> 	        || condition)) {
> 
> The above is my personally preferred style.
> 
That seems fine to me.  And in some areas of the tree, nearly 100% of
other contributors, too.

My personally preferred style is the single spaced variant, that also
conforms to the strict letter of CodingStyle, to wit:

   Use one space around (on each side of) most binary and ternary operators


>> 	if (condition &&
>>              condition && (condition || condition ||
>> 	    condition)) {
> 
> Except for the odd spacing, this is the significant
> majority of net/ style.
> 
> The leading style was < 10%.  It's less now.
> 
That's only true in net/ -- since the overall tree was 18.7%, with
net/ < 10%, the density was *much* higher elsewhere.

But more important, at least to my thinking, is keeping patches simple
by conforming to the *existing* style in the section of code.  No
sweeping changes!

