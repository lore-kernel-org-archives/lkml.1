Return-Path: <linux-kernel-owner+w=401wt.eu-S933301AbXHDTiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbXHDTiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765488AbXHDTiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:38:46 -0400
Received: from gateway.howardsilvan.com ([64.146.212.27]:47522 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764445AbXHDTip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:38:45 -0400
Message-ID: <46B4D5BF.6070901@howardsilvan.com>
Date: Sat, 04 Aug 2007 12:38:39 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Robert Hancock <hancockr@shaw.ca>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-serial@vger.kernel.org,
       tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no> <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com> <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl> <46AA2748.80703@howardsilvan.com> <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl> <46AA3801.7090204@shaw.ca> <20070728092842.GC26443@flint.arm.linux.org.uk> <Pine.LNX.4.64N.0707301040320.12082@blysk.ds.pg.gda.pl> <46B1F0CB.9060106@rtr.ca> <46B202DE.5000709@shaw.ca> <46B20662.6080606@rtr.ca>
In-Reply-To: <46B20662.6080606@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:

> The "fix" could be to have the serial IRQ handler never unmask 
> interrupts,
> but that's a bit unsociable to others.  The IDE stuff really needs to not
> do so much during the actual IRQ handler.
>
> Ingo's RT patches would probably fix all of this.


I did a Fedora 7 installation and installed Ingo's kernel from here:

http://people.redhat.com/mingo/realtime-preempt/yum-testing/yum/i686/kernel-rt-2.6.21-0182.rt11cfsv17.i686.rpm

Even then, the problem still occurs, unfortunately.

Thanks,

Lee.
