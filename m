Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689Ab0AZXCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab0AZXCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248Ab0AZXCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:02:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39174 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab0AZXCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:02:50 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@ZenIV.linux.org.uk>,
       Tavis Ormandy <taviso@google.com>, Jeff Dike <jdike@addtoit.com>,
       Julien Tinnes <jln@google.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [06/11] tty: fix race in tty_fasync
References: <20100126191624.538119758@mini.kroah.org>
	<m1bpggy7bt.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.1001261357390.3574@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 26 Jan 2010 15:02:38 -0800
In-Reply-To: <alpine.LFD.2.00.1001261357390.3574@localhost.localdomain> (Linus Torvalds's message of "Tue\, 26 Jan 2010 14\:11\:28 -0800 \(PST\)")
Message-ID: <m14om8xyep.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, 26 Jan 2010, Eric W. Biederman wrote:
>
>> Greg KH <gregkh@suse.de> writes:
>> 
>> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
>> 
>> Only that __f_setown by way of f_modown unconditionally enables interrupts.  So
>> without touching f_modown as well in mainline we have nasty sounding lockdep warnings.
>
> Hmm. That seems to be true in mainline too, isn't it?

Yes.  We are having that conversation in the thread:
   "[2.6.33-rc5] starting emacs makes lockdep warning"

Eric
