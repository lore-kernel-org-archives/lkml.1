Return-Path: <linux-kernel-owner+w=401wt.eu-S934139AbXEGOuC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139AbXEGOuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:50:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXEGOt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:49:58 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:29757 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbXEGOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=CVioJaxzRk5lyB6SAWnahHajByj7rXBjYHOYHiI5dsamieWgx3N7/qp4ro6a3tdMWECbhZ8bwV84CNCjB1o00hcdykKoYf4P6InR7DHHcaoPMqYCCOLZH4FF8WHoY5X8m9ex4/dUpXLgCVnwrTmqgiedZkv52W9AmfdJAhWpqL8=
Date: Mon, 7 May 2007 16:48:37 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Don Fry <pcnet32@verizon.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Strange soft lockup detected message (looks like spin_lock bug in pcnet32)
Message-ID: <20070507144837.GA30865@slug>
References: <20070504141024.GB8753@csclub.uwaterloo.ca> <20070504143326.GD24769@slug> <20070504151934.GA8754@csclub.uwaterloo.ca> <20070504153438.GE24769@slug> <20070504154009.GE8751@csclub.uwaterloo.ca> <20070504174456.GC8753@csclub.uwaterloo.ca> <20070504175017.GD8753@csclub.uwaterloo.ca> <20070504182433.GA11595@verizon.net> <20070504190236.GE8753@csclub.uwaterloo.ca> <20070507140807.GF8753@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507140807.GF8753@csclub.uwaterloo.ca>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 10:08:07AM -0400, Lennart Sorensen wrote:
> On Fri, May 04, 2007 at 03:02:36PM -0400, Lennart Sorensen wrote:
> > Well I don't know, but something is going wrong and causing the soft
> > lock up.  I must admit I am surprised if an interrupt can occour while
> > handling an interrupt, but then again maybe that is supposed to be
> > allowed.
> 
> I tried building a kernel where the only change was enabling the spin
> lock debugging.  It doesn't fail, while without spin lock debugging it
> seemed to fail very frequently.  Darn!  I hate when debugging makes hides
> the problem.
Can you try running on another Geode LX system, just to rule out a
hardware problem on you board?

Regards,
Frederik
