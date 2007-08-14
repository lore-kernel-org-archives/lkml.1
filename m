Return-Path: <linux-kernel-owner+w=401wt.eu-S936951AbXHNXAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936951AbXHNXAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936939AbXHNW7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:59:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53648 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936947AbXHNW7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:59:31 -0400
Subject: Re: kfree(0) - ok?
From: Arjan van de Ven <arjan@infradead.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46C233CB.9000602@am.sony.com>
References: <46C233CB.9000602@am.sony.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 14 Aug 2007 15:55:48 -0700
Message-Id: <1187132149.2618.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-08-14 at 15:59 -0700, Tim Bird wrote:
> Hi all,
> 
> I have a quick question.
> 
> I'm trying to resurrect a patch from the Linux-tiny patch suite,
> to do accounting of kmalloc memory allocations.  In testing it
> with Linux 2.6.22, I've found a large number of kfrees of
> NULL pointers.
> 
> Is this considered OK?  Or should I examine the offenders
> to see if something is coded badly?

kfree(NULL) is explicitly ok and it saves code size to not check
anywhere
(the idea is that kfree(kmalloc(...)); is a guaranteed safe nop)

NULL is not 0 though.


