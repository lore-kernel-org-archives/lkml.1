Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbZH0C4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbZH0C4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZH0C4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:56:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbZH0C4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:56:32 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, peterz@infradead.org,
       raziebe@gmail.com, maximlevitsky@gmail.com, cfriesen@nortel.com,
       efault@gmx.de, riel@redhat.com, wiseman@macs.biu.ac.il,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
References: <1251298443.4791.7.camel@raz> <1251300625.18584.18.camel@twins>
	<alpine.DEB.1.10.0908261136590.9933@gentwo.org>
	<1251302598.18584.31.camel@twins>
	<alpine.DEB.1.10.0908261211340.9933@gentwo.org>
	<20090826180407.GA13632@elte.hu>
	<alpine.DEB.1.10.0908261509580.9933@gentwo.org>
	<20090826193252.GA14721@elte.hu>
	<alpine.DEB.1.10.0908261627110.5554@gentwo.org>
	<20090826135041.e6169d18.akpm@linux-foundation.org>
	<20090826213400.GA25536@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 26 Aug 2009 22:55:17 -0400
In-Reply-To: <20090826213400.GA25536@elte.hu> (Ingo Molnar's message of "Wed, 26 Aug 2009 23:34:00 +0200")
Message-ID: <y0mtyzut17u.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> [...]
>
>> Don't get all religious about this.  If the change is clean, 
>> maintainable and useful then there's no reason to not merge it.

> Precisely.  This feature as proposed here hinders the correct
> solution being implemented - and hence hurts long term
> maintainability and hence is a no-merge right now.

(Does it "hinder" this in any different way than the following, as in
possibly reducing "pressure" for it?)

> [It also weakens the pressure to fix latencies for a much wider set
> of applications, hence hurts the quality of Linux in the long
> run. (i.e. is a net step backwards)]

How would you differentiate the above sentiment from "perfect is the
enemy of the good"?


- FChE
