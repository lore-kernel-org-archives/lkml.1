Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbXJPEEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbXJPEEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 00:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXJPEEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 00:04:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58665 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbXJPEEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 00:04:05 -0400
Date: Mon, 15 Oct 2007 22:04:01 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: david@lang.hm
Cc: Greg KH <greg@kroah.com>, Rob Landley <rob@landley.net>,
       Julian Calaby <julian.calaby@gmail.com>, Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
Message-ID: <20071016040401.GA15744@parisc-linux.org>
References: <200710112011.22000.rob@landley.net> <200710150304.00901.rob@landley.net> <646765f40710150206j75af4c4dwac4f4565451b64b1@mail.gmail.com> <200710150508.37332.rob@landley.net> <20071015173357.GB5738@kroah.com> <Pine.LNX.4.64.0710151952250.3949@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710151952250.3949@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 07:54:22PM -0700, david@lang.hm wrote:
> do PCI devices reorder their bus numbers spontaniously, or only if you 
> change the hardware?

The only system I've had that reordered PCI bus numbers was when I had a
partitionable system and changed the partitioning.  Not quite "change
the hardware", but neither was it "spontaneous".  It was certainly
unexpected (for me).

Greg probably has quite different examples.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
