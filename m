Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbYGWWOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbYGWWOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYGWWO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:14:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbYGWWO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:14:27 -0400
Message-ID: <4887ACD5.1020202@redhat.com>
Date: Wed, 23 Jul 2008 18:12:37 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Arjan van de Ven <arjan@infradead.org>, Rik van Riel <riel@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: systemtap & backward compatibility, was Re: [RFC] systemtap:
  begin the process of using proper kernel APIs
References: <487E8CE4.70105@redhat.com>	<1216259391.3358.85.camel@localhost.localdomain>	<1216304290.5515.11.camel@localhost.localdomain>	<1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain>	<y0m7ibkjrcj.fsf@ton.toronto.redhat.com>	<1216325546.5515.63.camel@localhost.localdomain>	<20080717202634.GI18295@redhat.com>	<1216328769.5515.78.camel@localhost.localdomain>	<20080717213355.GJ18295@redhat.com>	<20080722140015.37628ea4@bree.surriel.com>	<20080723150434.GC11191@redhat.com>	<20080723082856.334f9c17__2909.60763018138$1216827051$gmane$org@infradead.org> <y0m3am0blj2.fsf@ton.toronto.redhat.com>
In-Reply-To: <y0m3am0blj2.fsf@ton.toronto.redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

Frank Ch. Eigler wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
[...]
>> (and when it's seen it gets a rather luke warm reception, but that's
>> a different story).
> 
> I hope the backward compatibility issue, as it stands today, helps
> explain the reasons for the current deal with kprobes.

I understood that the current deal with kprobes is also for integrating
user probe logic and kernel probe logic.
Obviously, it is hard uprobe to provide same symbol_name interface,
because it requires to access(and analyze) userspace symbol
information from kernel.

> In the interim (before we come up with a way of moving more
> kernel-coupled systemtap code into kernel.org/git), would y'all
> consider an arrangement?  Those of you who care about systemtap, and
> are intending to make an incompatible kernel/module interface change,
> please run the systemtap testsuite before & after.  If it regresses,
> send us a note or a patch.  If practical, we'll integrate it (and add
> any backward-compatibility hacks if needed) into systemtap.

Hmm, I think it's very costly way for both of kernel developers and
systemtap developers.
>From the long term of viewpoint, I think it's better (less costly)
to merge systemtap runtime/tapset into upstream kernel and maintain
it. Then, we can stabilize its API by ourselves on upstream.
Since it reduces the catchup/maintenance cost and it enables users
to use stap on upstream kernel, I think it is benefit for both.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

