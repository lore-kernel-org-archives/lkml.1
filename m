Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475Ab0AALlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab0AALlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 06:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267Ab0AALlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 06:41:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55986 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab0AALlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 06:41:49 -0500
To: daw-news@taverner.cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: disablenetwork facility. (v4)
References: <20091229050114.GC14362@heat> <m1y6km11lj.fsf@fess.ebiederm.org>
	<hhev6r$n8b$1@taverner.cs.berkeley.edu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 01 Jan 2010 03:41:43 -0800
In-Reply-To: <hhev6r$n8b$1@taverner.cs.berkeley.edu> (David Wagner's message of "Wed\, 30 Dec 2009 07\:24\:11 +0000 \(UTC\)")
Message-ID: <m1ws02hx1k.fsf@fess.ebiederm.org>
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

daw@cs.berkeley.edu (David Wagner) writes:

> Eric W. Biederman wrote:
>>The problem with the disable_network semantics you want
>>is that they allow you to perform a denial of service attack
>>on privileged users.  An unprivileged DOS attack is unsuitable
>>for a general purpose feature in a general purpose kernel.
>
> I'm not persuaded yet.

I won't try hard to persuade you if you drop me off the cc list.

> When you talk about DOS, let's be a bit more precise.  disablenetwork
> gives a way to deny setuid programs access to the network.  It's not a
> general-purpose DOS; it's denying access to the network only.  And the
> network is fundamentally unreliable.  No security-critical mechanism
> should be relying upon the availability of the network.

The audit daemon should not rely on netlink?

> So while I certainly can't rule out the possibility that disablenetwork
> might introduce minor issues, I think there are fundamental reasons to
> be skeptical that disablenetwork will introduce serious new security
> problems.

For me the case is simple.  I have seen several plausible sounding
scenarios that get most of the way there.  I know I am stupid when
it comes to security and that people exploiting problems are going
to be looking harder than I will.  Therefore I think there is
a reasonable chance this will introduce a security hole for someone.

Eric
