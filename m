Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbXEUKsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbXEUKsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbXEUKsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:48:32 -0400
Received: from as3.cineca.com ([130.186.84.211]:38095 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbXEUKsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:48:32 -0400
Message-ID: <465178E6.60305@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] log out-of-virtual-memory events
References: <E1Hp5RZ-0001CF-00@calista.eckenfels.net>	<464ED292.8020202@users.sourceforge.net> <20070520203209.ec952a84.akpm@linux-foundation.org>
In-Reply-To: <20070520203209.ec952a84.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 21 May 2007 12:48:33 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 19 May 2007 12:34:01 +0200 (MEST) Andrea Righi <righiandr@users.sourceforge.net> wrote:
> 
>> Print informations about userspace processes that fail to allocate new virtual
>> memory.
> 
> Why is this useful?
> 

Well... in strict overcommit mode (overcommit_memory=2) this is the only way to
track down problems of the (bad-designed) user applications that exit when they
receive a -ENOMEM without logging anything... and, anyway, it could be an
additional aid in figuring out what is going wrong on inside a system. BTW, I
don't think it should be enabled by default, so this is the reason why it should
depend on print_fatal_signals patch.

-Andrea
