Return-Path: <linux-kernel-owner+w=401wt.eu-S1751307AbXBZQA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbXBZQA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXBZQA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:00:56 -0500
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:59677 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbXBZQAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:00:55 -0500
In-Reply-To: <1172505207.11949.15.camel@localhost.localdomain>
References: <200612112059.kBBKx1j7022473@hera.kernel.org> <1172448057.3971.9.camel@shinybook.infradead.org> <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org> <1172452660.3971.33.camel@shinybook.infradead.org> <Pine.LNX.4.64.0702251940500.12485@woody.linux-foundation.org> <1172462466.3971.46.camel@shinybook.infradead.org> <1172505207.11949.15.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <f42ffce99aed41ad91cb96c10e67d908@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: David Woodhouse <dwmw2@infradead.org>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: Make sure we populate the initroot filesystem late enough
Date: Mon, 26 Feb 2007 17:00:49 +0100
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> And check that we didn't end up stupidly having the initrd share a page
> with something else ... (like not aligned end or such thingy).

David tested that yesterday, it's not the case.  Too bad,
would have been too easy ;-)


Segher

