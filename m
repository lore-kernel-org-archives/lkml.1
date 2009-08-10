Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZHJPey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZHJPey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZHJPey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:34:54 -0400
Received: from kroah.org ([198.145.64.141]:36170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZHJPex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:34:53 -0400
Date: Mon, 10 Aug 2009 08:04:24 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: subrata@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Ingo Molnar <mingo@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       balbir <balbir@linux.vnet.ibm.com>
Subject: Re: [BUILD FAIL] Linus git Tree on x86_32 for randconfig dated
 10/08/2009
Message-ID: <20090810150424.GA7099@kroah.com>
References: <1249905728.5187.21.camel@subratamodak.linux.ibm.com>
 <1249907812.17467.126.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1249907812.17467.126.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 02:36:52PM +0200, Peter Zijlstra wrote:
> On Mon, 2009-08-10 at 17:32 +0530, Subrata Modak wrote:
> > Hi Greg/Ingo,
> > 
> > Todayś Linus git tree produced the following build failure on
> > randconfig:
> > 
> > ......
> > ......
> > (.text+0xf280): multiple definition of `CmmRxnonRalinkFrameIndicate'
> > drivers/staging/rt2860/built-in.o:(.text+0x12d3f): first defined here
> > drivers/staging/rt2870/built-in.o: In function `RTMPEnableRxTx':
> 
> Its staging, what do you expect ;-)

Heh, yes, both of these drivers can not be built into the kernel at the
same time.  That's a configuration that "normal" people will not hit.

If you wish to send a Kconfig patch to resolve this, I'll gladly accept
it.

thanks,

greg k-h
