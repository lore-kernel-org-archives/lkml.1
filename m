Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbZLVL3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbZLVL3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZLVL3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:29:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:45912 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZLVL3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:29:30 -0500
Date: Tue, 22 Dec 2009 12:31:48 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, efault@gmx.de
Subject: Re: 2.6.33-rc1 unusable due to scheduler issues, circular locking,
 WARNs and BUGs
Message-ID: <20091222123148.6d922bb4@infradead.org>
In-Reply-To: <1261471720.4937.9.camel@laptop>
References: <1261441037.3273.254.camel@localhost>
	<1261471720.4937.9.camel@laptop>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009 09:48:40 +0100
Peter Zijlstra <peterz@infradead.org> wrote:
> 
> If this revert doesn't help, could you please also provide the output
> of addr2line -e vmlinux <FAULT_IP> ?

or even better, use scripts/markup_oops.pl to get a full disassembly +
C code of where the crash happens
