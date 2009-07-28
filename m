Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbZG1HFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbZG1HFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZG1HFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:05:23 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:48521 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZG1HFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:05:23 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/1 tip] perf top: Move hard coded list to
 /etc/perfconfig/symbols.skip
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090728001041.GG28349@ghostprotocols.net>
References: <20090728001041.GG28349@ghostprotocols.net>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 09:07:56 +0200
Message-Id: <1248764876.6987.2713.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 21:10 -0300, Arnaldo Carvalho de Melo wrote:
> This also paves the way to add more symbol lists to be filtered out,
> spinlock anyone?

Doesn't seem like a good idea to filter out symbols that actually affect
performance -- such as spinlocks.

But yeah, the patch makes sense and allows people to mess up their own
environments :-)

Queued this and the previous one, Thanks!

