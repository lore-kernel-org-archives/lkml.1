Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbZAIG1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbZAIG1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZAIG0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:26:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:7998 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZAIG0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:26:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=Ae18FrpBIMPbQlglE40etDeBVH8uLC7+CfvOUSWRaqczle7XANQDp1ZBy6EAvIORC
	zP2MvOpnttKeDuuMzyIsw==
MIME-Version: 1.0
In-Reply-To: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 8 Jan 2009 22:26:46 -0800
Message-ID: <6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.144
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 9:32 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Motivation: Simply classify Applications by cgroup
>  When using cgroup for classifying applications, some kind of "control" or
>  "account" subsys must be used. For flexible use of cgroup's nature of
>  classifying applications, NOOP is useful. It can be used regardless of
>  resource accounting unit or name spaces or some controls.
>  IOW, NOOP cgroup allows users to tie PIDs with some nickname.

I agree that the idea is useful. But to me it seems to a bit
artificial that you still have to mount some kind of subsystem purely
to get the grouping, and that you can only have one such grouping.

I think I'd prefer the ability to mount a cgroups hierarchy without
*any* subsystems (maybe with "-o none"?) which would give you a
similar effect, but without you needing to know about a special no-op
subsystem, and would allow you to have multiple "no-op" groupings.

Paul
