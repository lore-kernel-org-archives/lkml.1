Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbXJaAIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbXJaAIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXJaAIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:08:46 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34904
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbXJaAIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:08:45 -0400
Date: Tue, 30 Oct 2007 17:16:18 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Peter Dolding <oiaohm@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <4727C06A.4060005@gmail.com>
Message-ID: <Pine.LNX.4.64.0710301713260.8703@asgard.lang.hm>
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl> 
 <4726377A.4080807@crispincowan.com> <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>
 <Pine.LNX.4.64.0710301136560.31325@fbirervta.pbzchgretzou.qr>
 <4727C06A.4060005@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Peter Dolding wrote:

> MultiAdmin loaded before Selinux breaks Selinux since Multi Admin rules are 
> applied over using Selinux rules.  This is just the way it is stacking LSM's 
> is Just not healthy you always risk on LSM breaking another.  Part of the 
> reason why I have suggested a complete redesign of LSM.  To get away from 
> this problem of stacking.

since the method of stacking hasn't been determined yet, you can't say 
this.

it would be possible for MultiAdmin to grant additional access, that 
SELinux then denies for it's own reasons.

if the SELinux policy is written so that it ignores capabilities, and 
instead just looks at uid0 then that policy is broken in a stacked 
environment, but it's the polciy that's broken, not the stacking.

yes, there will be interactions that don't make sense, but just becouse 
something can be used wrong doesn't mean that there aren't other cases 
where it can be used properly.

David Lang
