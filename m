Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYFKVv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYFKVv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 17:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYFKVvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 17:51:49 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:19643 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbYFKVvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 17:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Y62t0f0eXExyXoLKlpZKJNDVCyCXFpNHU9i0/kEuKwJGuHn9Luxj6mV3JYGFFKCQiS
         XdcMBfhpYPbvhMAIrhHu4hnFA6CweLKv7szrkTq71g9Z5Q+F+NaaUSzNvKBhcs/GSqdZ
         DLXNRgnEvBjIibbhlV/APvrYaRcsP79pmf/MI=
Message-ID: <485048EC.2080608@gmail.com>
Date: Thu, 12 Jun 2008 06:51:40 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>	 <20080404012147.abf8a598.akpm@linux-foundation.org>	 <484F31B8.8030001@gmail.com>	 <dd18b0c30806110045s6d19a034yd89b892441bd1621@mail.gmail.com> <dd18b0c30806111131gc1b506cva12f577ebb4afdf9@mail.gmail.com>
In-Reply-To: <dd18b0c30806111131gc1b506cva12f577ebb4afdf9@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> O.K. I applied the patch here is what I'm seeing:
> 
> [  920.237141] end_request: I/O error, dev sr0, sector 2931560
> [  920.237141] Buffer I/O error on device sr0, logical block 366445
> [  920.237141] Buffer I/O error on device sr0, logical block 366446
> [  920.237141] Buffer I/O error on device sr0, logical block 366447
> [  920.237141] Buffer I/O error on device sr0, logical block 366448
> [  920.237141] Buffer I/O error on device sr0, logical block 366449
> [  920.237141] Buffer I/O error on device sr0, logical block 366450
> [  920.237141] Buffer I/O error on device sr0, logical block 366451
> [  920.237141] Buffer I/O error on device sr0, logical block 366452
> [  920.237141] Buffer I/O error on device sr0, logical block 366453
> [  920.237141] Buffer I/O error on device sr0, logical block 366454
> [  925.431105] __ratelimit: 10100 messages suppressed
> [  925.431118] Buffer I/O error on device sr0, logical block 371516
> [  930.772658] __ratelimit: 2407 messages suppressed
> [  930.772658] Buffer I/O error on device sr0, logical block 372720
> [  935.674943] __ratelimit: 6995 messages suppressed
> [  935.674955] Buffer I/O error on device sr0, logical block 376218
> [  940.685317] __ratelimit: 16949 messages suppressed
> [  940.685329] Buffer I/O error on device sr0, logical block 384693
> [  945.770547] __ratelimit: 17881 messages suppressed
> [  945.770558] Buffer I/O error on device sr0, logical block 393634
> [  950.777243] __ratelimit: 19031 messages suppressed
> [  950.777243] Buffer I/O error on device sr0, logical block 403150
> [  955.788427] __ratelimit: 19035 messages suppressed
> [  955.788439] Buffer I/O error on device sr0, logical block 412668
> [  961.575327] __ratelimit: 16603 messages suppressed
> [  961.575338] Buffer I/O error on device sr0, logical block 420970
> [ 1006.919733] __ratelimit: 9315 messages suppressed
> 
> Almost as if the drive is taking to long to think, by then the cache
> has run out, and the FPS changes,
> the movie itself doesn't become choppy like before, just freezes.
> If you have any other ideas I'm up for that to see.
> regards;

Eh.... strange.  Can you post full kernel log?  And does the dvd work if
you restart playing?

-- 
tejun
