Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZCaIr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZCaIr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZCaIrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:47:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38938 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZCaIrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:47:40 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       jbeulich@novell.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, ego@in.ibm.com,
       adobriyan@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] sysctl:  lockdep support for sysctl reference counting.
References: <49B91A7E.76E4.0078.0@novell.com>
	<tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
	<1236934491.5188.209.camel@laptop> <49BA33BE.76E4.0078.0@novell.com>
	<1236937423.22914.3698.camel@twins> <20090313103828.GB31094@elte.hu>
	<m1d4cd9n4k.fsf@fess.ebiederm.org> <20090320085205.GB16021@elte.hu>
	<m14oxo8qis.fsf@fess.ebiederm.org> <20090320182404.GA31629@elte.hu>
	<1237575134.4667.5.camel@laptop> <1237577688.4667.68.camel@laptop>
	<m1iqm3xr2n.fsf_-_@fess.ebiederm.org>
	<m1eiwrxr05.fsf_-_@fess.ebiederm.org>
	<m1ab7fxqxw.fsf_-_@fess.ebiederm.org>
	<20090330152616.7cc2c87c.akpm@linux-foundation.org>
	<1238487045.28248.1774.camel@twins>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 31 Mar 2009 01:47:29 -0700
In-Reply-To: <1238487045.28248.1774.camel@twins> (Peter Zijlstra's message of "Tue\, 31 Mar 2009 10\:10\:45 +0200")
Message-ID: <m1y6umcc4e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: peterz@infradead.org, netdev@vger.kernel.org, adobriyan@gmail.com, ego@in.ibm.com, linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, jbeulich@novell.com, mingo@elte.hu, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, 2009-03-30 at 15:26 -0700, Andrew Morton wrote:
>> So I merged these two patches.  I designated them as to-be-merged via
>> Alexey, with a Cc:Peter (IOW: wakey wakey ;))
>
> Ah, I was under the impression they weren't quite finished yet,
> apparently I was mistaken.
>
> Eric, didn't you need recursive locks fixed and such?

In theory.  In practice I removed the one case that could legitimately
recurse.

> Let me have a look at them.
