Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbXINJth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbXINJth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 05:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXINJt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 05:49:26 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3554 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXINJtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 05:49:24 -0400
Date: Fri, 14 Sep 2007 10:49:05 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: 2.6.23-rc6: hanging ext3 dbench tests
Message-ID: <20070914094905.GA32670@shadowen.org>
References: <20070911124202.GI9556@shadowen.org> <alpine.LFD.0.999.0709110949250.16478@woody.linux-foundation.org> <20070911173049.GA10499@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911173049.GA10499@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 06:30:49PM +0100, Andy Whitcroft wrote:
> Annoyingly this seems to be intermittent, and I have not managed to get
> a machine into this state again yet.  Will keep trying.

Ok, I have been completly unsuccessful in reproducing this.  Dispite
having two distinct machines showing this behaviour.  I have neither
been able to reproduce it with those machine on 2.6.23-rc6 nor has any
of the testing of any of the -git releases which follow thrown this
error.  I have run about 10 repeats of the jobs which failed too and
none of those have thrown the same error.

It is pretty clear from the dbench output that the problem is/was real,
that its not some artifact of the test harness.  I am a loss as to how to
get this to trigger again.

I guess I will keep monitoring the ongoing tests for new instances.  I
will also look to getting the sysrq-* stuff triggered automatically on
job timeout as that seems like a sane plan in all cases.

Frustrated.

-apw
