Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYCDFvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYCDFvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYCDFvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:51:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:59118 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751229AbYCDFvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:51:13 -0500
X-Authenticated: #12956409
X-Provags-ID: V01U2FsdGVkX19hg5ZZuuJhX1zZeBDg6VreZauYjT5h7W8XRE4+HD
	S/fLIdW2gmSlzd
Message-ID: <47CCE36D.3020000@gmx.net>
Date: Tue, 04 Mar 2008 06:51:41 +0100
From: Cyrus Massoumi <cyrusm@gmx.net>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Diego Calleja <diegocg@gmail.com>,
       Stephen Cuppett <cuppett@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: Performance versus FreeBSD 7.0
References: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com>	<20080229155408.116fa5a1.diegocg@gmail.com>	<200803040004.52299.nickpiggin@yahoo.com.au>	<47CC4B3F.8060405@gmx.net> <p73y78z5r3k.fsf@bingen.suse.de>
In-Reply-To: <p73y78z5r3k.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Cyrus Massoumi <cyrusm@gmx.net> writes:
>> IIRC, going to fine-grained file locking gave them a huge boost in
>> this particular benchmark (and maybe others).
> 
> What locking? You mean their equivalent of i_mutex? There are 
> already file systems on Linux that don't use it significantly
> for write.
> 
>> As I said on lwn.net Peter Zijlstra posted a patch to break the global
>> file list lock about a year ago [1], but I don't think it was ever
>> merged. Here [2] are some numbers for the patchset.
> 
> The file_list_lock is only for open/close which MySQL is very unlikely
> to do in its fast path. You're totally on the wrong path here I think.

Yes, Nick already corrected me, sorry for the noise :)

