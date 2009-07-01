Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbZGAA1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbZGAA1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZGAA1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:27:07 -0400
Received: from smtp-out.google.com ([216.239.33.17]:23621 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZGAA1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:27:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=aaS4oMmdsGLIbBwRbUJIqrm8B45nJ1/9afF1Y2UJXv07/p8vqObpsloBBkdK2g6Kb
	DwjCJpIu/PIIUIMrMgDsw==
MIME-Version: 1.0
In-Reply-To: <20090701090959.4cbdb03e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090630180109.f137c10e.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090630180344.d7274644.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830906300215q56bda5ccnc99862211dc65289@mail.gmail.com>
	 <20090630182304.8049039c.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830906300918i3e3f8611r6d6fb7873c720c70@mail.gmail.com>
	 <20090701084037.2c3f53f7.nishimura@mxp.nes.nec.co.jp>
	 <20090701090959.4cbdb03e.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 30 Jun 2009 17:27:02 -0700
Message-ID: <6599ad830906301727wcb6b292uc3c46451f8844392@mail.gmail.com>
Subject: Re: [PATCH 2/2] cgroup: exlclude release rmdir
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 5:09 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 1 Jul 2009 08:40:37 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
>
>> On Tue, 30 Jun 2009 09:18:03 -0700, Paul Menage <menage@google.com> wrote:
>> > On Tue, Jun 30, 2009 at 2:23 AM, KAMEZAWA
>> > Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > > This patch is _not_ tested by Nishimura.
>> >
>> > True, but it's functionally identical to, and simpler than, the one
>> > that was tested.
>> >
>> I agree.
>> I'll test with both of these patches folded.
>>
> Hm,ok. I'll post merged one today.
> But I don't like cosmeticized bugfix patch ;(
>

It only looks "cosmeticized" because of the evolution of your fix. The
first patch added a new function that exposed internal details of
cgroups, and the second patch removes the addition in favour of a
different new function that doesn't expose internal details as much; a
single patch that just adds the simpler new function is easier to
judge as intuitively correct (separately from Daisuke's testing) than
one that exposes more internal details.

Paul
