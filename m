Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYBTDMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYBTDMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbYBTDMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:12:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28897 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYBTDMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:12:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=cyDOR8ZEgBqIoyXQMcDXMIFfmH1opZgSzjTzOwCy+i5sX2RAC7u/2ZjVXjGpJPwZq
	JyX9kvmckU+tthMHGlhOA==
Message-ID: <6599ad830802191912t33cca90dx590791d9cdb29534@mail.gmail.com>
Date: Tue, 19 Feb 2008 19:12:05 -0800
From: "Paul Menage" <menage@google.com>
To: "Nick Andrew" <nick@nick-andrew.net>
Subject: Re: Improve init/Kconfig help descriptions [PATCH 6/9]
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080220025431.GA10766@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219140609.GA26619@tull.net> <20080219151214.GD27352@tull.net>
	 <6599ad830802191804y171282c1m646bdb47b83e2bc2@mail.gmail.com>
	 <20080220025431.GA10766@tull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 6:54 PM, Nick Andrew <nick@nick-andrew.net> wrote:
>
> config CGROUPS
>         bool "Control Group support"
>         help
>           Control Groups enables processes to be tracked and grouped
>           into "cgroups". This enables you, for example, to associate
>           cgroups with certain CPU sets using "cpusets".
>
>           When enabled, a new filesystem type "cgroup" is available
>           and can be mounted to control cpusets and other
>           resource/behaviour controllers.
>
>           See <file:Documentation/cgroups.txt> for more information.
>
>           If unsure, say N.
>
>
> I don't think that description is as clear as it could be. From
> the non-kernel-developer point of view, that is.

Originally this wasn't a user-selectable config value, it was
auto-selected by any subsystem that needed it. I think that was nicer
from the user-experience, and it would eliminate the need for this
documentation but there were concerns that this triggered unspecified
brokenness in the Kbuild system.

>
> Re "other resource/behaviour controllers", what in particular?
> I take it that our current controllers are cpusets, scheduler,
> CPU accounting and Resource counters?

Resource counters aren't a resource controller, they're a helper
library. The others are good examples, as is the memory controller
that's just been added to 2.6.25.

Paul
