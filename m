Return-Path: <linux-kernel-owner+w=401wt.eu-S937987AbXG3FMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937987AbXG3FMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 01:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbXG3FMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 01:12:30 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:16865 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbXG3FM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 01:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XAU2kuLvU6tj2CB7e9gdgXX9JFrDvABQnXAlLDdKV2+AkrxfhSmA75m+1jW52Wip7BK92wz2ewLYYsO6VFaBFi2Py3bS7hGJx87QYYWTlqDmDAnXS49RSl8OtvippftMej/3tDna9w2PRcOj9e8TPUg7UyWCAsrH7oIizURiQrk=
Message-ID: <b21f8390707292212n2c580bd8o4b7654e62cfe6786@mail.gmail.com>
Date: Mon, 30 Jul 2007 15:12:28 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Cc: "George Sescher" <gesacs@gmail.com>, "CK Mailinglist" <ck@vds.kolivas.org>,
       "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0707291612410.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185588279.1654.1.camel@localhost> <20070729150436.GA6598@elte.hu>
	 <a12e280d0707291604s618c0b14lc8572b2f48cd4ca1@mail.gmail.com>
	 <alpine.LFD.0.999.0707291612410.3442@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> For example, how hard is it for people to just admit that CFS actually
> does better than SD on a number of things? Including very much on the
> desktop.

Actually in benchmarks Ingo has quoted, SD was better on the desktop
(by a small margin).
CFS is still a bit bursty, though it has significantly improved with
age.  I know, I did those benchmarks.  That being said, I'm really
glad to see CFS in your git tree because the new framework around it
really improves the readability of the code, and actually makes it
easier to start experimenting with scheduler improvements from an
entire scheduler like SD to minor bits like priorities.

I have one concern - my benchmarking took load average as the common
denominator and CFS alters the way the load average is calculated, so
perhaps it wasn't a fair comparison.  That being said, they still
showed CFS could scale very well and SD did not, so considering we're
dealing with everything from wristwatches to BlueGene/L I believe the
right choice was made.  Those arguing for the 2% improvement that SD
would give them in their environment would be better off

a) helping port SD to the new scheduler framework
b) assisting Ingo in improving CFS to meet/exceed their requirements
c) giving practical assistance to anyone doing either of the above

I'm re-learning git and using my Copious Spare Time (tm) to do what I
can - but I have to admit I'm really in over my head.  But hey, if
Jeff Garzik can do it, so can I.  I remember when he couldn't grok C &
now he's got control over all our data :-)

-- 
Matt
