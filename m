Return-Path: <linux-kernel-owner+w=401wt.eu-S1761044AbYBTCFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044AbYBTCFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbYBTCFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:05:07 -0500
Received: from smtp-out.google.com ([216.239.45.13]:26149 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbYBTCFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:05:05 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hr22cpJQx6jp6l/VvYoWvHooIl4nSM+QrH+T0ETDtB+5uwJDb/SeJufXM/32aMgKj
	lmargzJ5yW8QxIBbbLywQ==
Message-ID: <6599ad830802191804y171282c1m646bdb47b83e2bc2@mail.gmail.com>
Date: Tue, 19 Feb 2008 18:04:57 -0800
From: "Paul Menage" <menage@google.com>
To: "Nick Andrew" <nick@nick-andrew.net>
Subject: Re: Improve init/Kconfig help descriptions [PATCH 6/9]
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080219151214.GD27352@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219140609.GA26619@tull.net> <20080219151214.GD27352@tull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 7:12 AM, Nick Andrew <nick@nick-andrew.net> wrote:
>  config CGROUPS
>         bool "Control Group support"
>         help
> -         This option will let you use process cgroup subsystems
> -         such as Cpusets
> +         Control Groups enables processes to be tracked and grouped
> +         into "cgroups". This enables you, for example, to associate
> +         cgroups with certain CPU sets using "cpusets".
>
> -         Say N if unsure.
> +         When enabled, a new filesystem type "cgroup" is available
> +         and can be mounted to control cpusets.

How about:

... cpusets and other resource/behaviour controllers.

Paul
