Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbXIZDhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbXIZDhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759946AbXIZDeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:34:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58069 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759553AbXIZDeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:34:08 -0400
Message-ID: <46F9D328.4030801@garzik.org>
Date: Tue, 25 Sep 2007 23:34:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@SteelEye.com,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: queued patches for SCSI for 2.6.24
References: <1190768402.8707.20.camel@localhost.localdomain> <20070925065233Q.tomof@acm.org> <1190770955.8707.23.camel@localhost.localdomain> <20070925073735U.tomof@acm.org> <46F9C5ED.6050505@garzik.org> <20070926025608.GA3899@parisc-linux.org>
In-Reply-To: <20070926025608.GA3899@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Sep 25, 2007 at 10:37:33PM -0400, Jeff Garzik wrote:
>> Are there any const-ness worries for scsi_host_template, or plans for 
>> the future?  I do not see any other examples of the host template 
>> members getting modified.
> 
> Goodness, Jeff, you haven't looked too hard.  There's dozens of examples
> I've come across trawling the horrible unmaintained drivers.  I'd love
> to see scsi_host_template become const, but it's not happening any time
> soon, and we can address this little piece when the time comes.

Well, sure, the driver is the owner of that memory.

We're talking about common code.

If everybody agrees SHT is R/W in the core, Fujita-san's patch is fine.

	Jeff



