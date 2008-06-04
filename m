Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYFDRbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYFDRbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYFDRbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:31:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:34433 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951AbYFDRbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:31:03 -0400
In-Reply-To: <1212580245.32207.51.camel@pmac.infradead.org>
References: <20080604180025.3ecd03ff.sfr@canb.auug.org.au> <48468091.5000102@linux.vnet.ibm.com> <1212580245.32207.51.camel@pmac.infradead.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <54a3f4cc48b03f9fe63be0bcd7c2ab20@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 4 - firmware/keyspan/mpr.fw.gen.S
Date: Wed, 4 Jun 2008 19:19:59 +0200
To: David Woodhouse <dwmw2@infradead.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> make[1]: *** No rule to make target
>> `/usr/local/autobench/autotest/tmp/build/linux/$(dir)', needed by
>> `firmware/keyspan/mpr.fw.gen.S'.  Stop.
>> make: *** [firmware] Error 2
>
> Hm, what version of make? Does .SECONDEXPANSION: not work everywhere?

It is a new feature in GNU make 3.81, which was released slightly
over two years ago.


Segher

