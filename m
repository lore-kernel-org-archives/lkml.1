Return-Path: <linux-kernel-owner+w=401wt.eu-S1758422AbXH1JMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbXH1JMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 05:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbXH1JMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 05:12:42 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:56992 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbXH1JMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 05:12:41 -0400
Date: Tue, 28 Aug 2007 02:12:17 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Message-ID: <20070828091217.GA1645@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <1186531609.22044.50.camel@imap.mvista.com> <20070808142059.GF30805@atjola.homenet> <20070827175431.GD784@frankl.hpl.hp.com> <1188237331.2435.255.camel@dhcp193.mvista.com> <20070827225555.GI784@frankl.hpl.hp.com> <1188256074.2435.272.camel@dhcp193.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188256074.2435.272.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Mon, Aug 27, 2007 at 04:07:54PM -0700, Daniel Walker wrote:
> On Mon, 2007-08-27 at 15:55 -0700, Stephane Eranian wrote:
> 
> > Yet the model name looks strange. So we need to run one more test,
> > as the fam/model is not enough. What we need to check is whether or
> > not this processor implements architectural perfmon or not.
> > 
> > Could you please compile and run the attached program and send me 
> > the output?
> 
> The output below is all the output ..
> 
> eax=0x7280201: version=1  num_cnt=2
> 
Then you have a Core Duo processor and the commit from Bjorn should
fix the problem. If it does not, then there is something else wrong.
Unfortunately, I do not have a Core Duo machine to try and reproduce.

-- 

-Stephane
