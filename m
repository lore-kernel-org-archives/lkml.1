Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZC3Wxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZC3Wxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZC3WxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:53:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35603 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZC3WxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:53:17 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, jbeulich@novell.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, ego@in.ibm.com,
       peterz@infradead.org, adobriyan@gmail.com, netdev@vger.kernel.org
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
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 30 Mar 2009 15:53:04 -0700
In-Reply-To: <20090330152616.7cc2c87c.akpm@linux-foundation.org> (Andrew Morton's message of "Mon\, 30 Mar 2009 15\:26\:16 -0700")
Message-ID: <m1k566k4hb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, netdev@vger.kernel.org, adobriyan@gmail.com, peterz@infradead.org, ego@in.ibm.com, linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, jbeulich@novell.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> So I merged these two patches.  I designated them as to-be-merged via
> Alexey, with a Cc:Peter (IOW: wakey wakey ;))

It is more sysctl than proc but whichever.  As long as people aren't
blind sided at the last minute I'm fine.

> Regarding this:
>
>> From: ebiederm@xmission.com (Eric W. Biederman)
>> ...
>> Signed-off-by: Eric Biederman <ebiederm@aristanetworks.com>
>
> It doesn't make a lot of sense to have a different Author: address,
> IMO.  So I rewrote the From: address to be ebiederm@aristanetworks.com,
> OK?

>From my perspective it does.  It is much easier to use my personal
email setup for doing kernel work.  But I need to indicate I am
signing off as an employee of AristaNetworks.  Saying aristanetworks
in my signed-off-by seems a little more official.

Eric

