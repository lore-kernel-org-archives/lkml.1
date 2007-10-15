Return-Path: <linux-kernel-owner+w=401wt.eu-S932417AbXJOSB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbXJOSB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbXJOSAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:00:55 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48272 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbXJOSAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:00:52 -0400
Date: Mon, 15 Oct 2007 12:00:50 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: Rob Landley <rob@landley.net>,
       James Bottomley <James.Bottomley@steeleye.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
Message-ID: <20071015180050.GB25488@parisc-linux.org>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015060015.GB32268@kroah.com> <200710150336.15774.rob@landley.net> <20071015172513.GA5738@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015172513.GA5738@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 10:25:13AM -0700, Greg KH wrote:
> Use mount-by-label instead, it's much saner and handles device name
> movement just fine (as does the UUID method that you seem to hate.)
> Look in /dev/disk/ for a wide range of options that you have in which to
> choose how to pick your block devices.

But you still have to spin up the disc to read the label (which seems
like a legitimate complaint to me).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
