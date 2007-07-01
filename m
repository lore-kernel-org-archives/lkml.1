Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbXGAQ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbXGAQ4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbXGAQ4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:56:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:62521 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbXGAQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AyIo92QjQnBGOTh8StcswY1AQrDxL+1ZBWCANwhaaw5aMBhTEFi824940f4asEyvffuvq0jxcXHdC6fJeMCPNydESd+kUGWfQ4LeDVbCe32Zn8rHVsIffSz4INxTNofFy9nFmoCTUGFpL0Xvcrm3w3vvSEboNTOMZ0PTtjbgFTU=
Message-ID: <439fa30707010956h1c467e28xc9eff37ebec523ad@mail.gmail.com>
Date: Sun, 1 Jul 2007 12:56:36 -0400
From: Dan <metalifloyd@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: PROBLEM: SATA AHCI driver significant throughput loss in 2.6.22-rc5-g75154f40-dirty
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20070630005747.9bc9ba40.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <439fa30706262117u2d5553dfp8395c6ca41574a8c@mail.gmail.com>
	 <20070630005747.9bc9ba40.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you able (as a matter of some urgency) to run a git bisection
> search to identify the offending commit?

For some reason I am no longer able to reproduce the problem. I've
tried several versions including the one I reported and I just can't
reproduce the problem. I accidentally overwrote the original kernel
that had the problem. The weird thing is even when I reset the git
tree to 2.6.22-rc5-g75154f40 and build it, the error is gone.

I've tested with the latest git and all seems well so far. I'll keep a
close eye out and will try to run bisect to find the problem. Sorry, I
should have done that in the first place (Didn't know about it).


-Dan
