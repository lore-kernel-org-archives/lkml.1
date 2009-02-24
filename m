Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZBXBVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZBXBVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZBXBVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:21:06 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:36754 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZBXBVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:21:03 -0500
Subject: Re: [RFC][PATCH 3/5] check files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090224011037.GB4797@us.ibm.com>
References: <20090219182007.B4B47C1F@kernel>
	 <20090219182009.1A3E8860@kernel> <20090223234911.GB2590@us.ibm.com>
	 <1235435430.26788.212.camel@nimitz>  <20090224011037.GB4797@us.ibm.com>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 17:20:59 -0800
Message-Id: <1235438459.26788.222.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 19:10 -0600, Serge E. Hallyn wrote:
> > This allows us to tell where and when we went wrong.  Take a process
> > that's been running for a month.  After 5 days it did something random
> > to keep it from being checkpointed.  You're going to have forgotten all
> > about it 25 days later.  This gives us an opportunity to spit into dmesg
> > or just plain log it.  It also gives the app some ability to reflect and
> > see what its uncheckpointable attributes are.  
> 
> Hmm.  In that case, rather than refuse checkpoint, I prefer that we make
> this a footnote in the /proc/$$/checkpointable output.

Yeah, that's cool.  If we were smart, we'd also get hooked into some of
the ftrace output so that we have a real chance of logging these things
and being able to go look at something about them down the line.

-- Dave

