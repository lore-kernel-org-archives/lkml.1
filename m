Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZCIIZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZCIIZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbZCIIZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:25:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:34564 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZCIIZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:25:25 -0400
Subject: Re: [BUG,2.6.29-rc7,s390] System goes into endless loop during
 boot or logon
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frans Pop <elendil@planet.nl>
Cc: linux-s390@vger.kernel.org,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200903090253.34173.elendil@planet.nl>
References: <200903080835.14032.elendil@planet.nl>
	 <200903080853.10704.elendil@planet.nl>
	 <200903090253.34173.elendil@planet.nl>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 09:25:18 +0100
Message-Id: <1236587118.8389.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 02:53 +0100, Frans Pop wrote:
> Follow-up to an issue reported on the linux-s390 list, seen in the 
> Hercules S/390 emulator.
> 
> On Sunday 08 March 2009, Frans Pop wrote:
> > Well, not quite. It does boot successfully and I do get a login prompt.
> > I can also login on the console or connect with SSH, but in both cases
> > the system again gets into some loop before I actually get a shell
> > prompt.
> 
> During the bisection series the system would sometimes enter the loop 
> during the boot procedure, before I tried to logon. After it enters the 
> loop one processor just goes racing at 100%.

Where? Do you have NMI watchdog output, or even sysrq-t?

