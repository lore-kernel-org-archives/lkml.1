Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbYIFQm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbYIFQm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYIFQms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:42:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:60540 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYIFQms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:42:48 -0400
Date: Sat, 6 Sep 2008 09:42:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: nice and hyperthreading on atom
Message-ID: <20080906094248.5930911a@infradead.org>
In-Reply-To: <1220715811849@dmwebmail.dmwebmail.chezphil.org>
References: <1220715811849@dmwebmail.dmwebmail.chezphil.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Sep 2008 16:43:31 +0100
"Phil Endecott" <phil_wueww_endecott@chezphil.org> wrote:

> Dear Experts,
> 
> I have an ASUS Eee with an Atom processor, which has hyperthreading 
> enabled.  If I have two processes, one nice and the other normal,
> they each get 50% of the CPU time.  Of course this is what you'd
> expect if the scheduler didn't understand that the two virtual
> processors are not really independent.  I'd like to fix it.
> 

but you cannot imfluence the cpu's scheduling of the instructions.

As an OS one COULD decide to just not schedule the nice task at all,
but then, especially on atom where HT has a high efficiency, your cpu
is mostly idle ...

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
