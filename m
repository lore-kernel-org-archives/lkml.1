Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbZBIRTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbZBIRTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZBIRTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:19:47 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:3511 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbZBIRTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:19:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DY13mt4QXGjTJMlSRUjdjlft5vQv3n8F+78gKMhGryO+YPtfmL0qrB1XsdOZFUEcf7
         X491IRqOoqxBiy9MDMavWnYSOt3EKZfHMJSWNlmq2JpcPyWOX6kzxEnqmi428g6r64/A
         MWL/qYi0qPJFlLdWXtMYxmiDYqlnHi/PQFTsI=
MIME-Version: 1.0
In-Reply-To: <20090209131653.GS7120@linux.vnet.ibm.com>
References: <20090206030543.GB8560@Krystal> <20090206045841.GA12995@Krystal>
	 <20090206130640.GB10918@linux.vnet.ibm.com>
	 <20090206163432.GF10918@linux.vnet.ibm.com>
	 <20090208224419.GA19512@Krystal>
	 <20090209041153.GR7120@linux.vnet.ibm.com>
	 <20090209045352.GA28653@Krystal>
	 <20090209131653.GS7120@linux.vnet.ibm.com>
Date: Mon, 9 Feb 2009 18:19:45 +0100
Message-ID: <36ca99e90902090919r297ad4c3re2248c321b36baf8@mail.gmail.com>
Subject: Re: [RFC git tree] Userspace RCU (urcu) for Linux (repost)
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Robert Wisniewski <bob@watson.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 14:16, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Sun, Feb 08, 2009 at 11:53:52PM -0500, Mathieu Desnoyers wrote:
>> Yes, I guess the signal is not so bad.
>
> Now if there were a /proc entry that listed out the tids of the
> currently running threads, then it might be possible to do something,
> especially for applications with many more threads than CPUs.
Do you mean something like: `ls /proc/$pid/tasks/*`? Or is this not
atomic enough?

Bert
