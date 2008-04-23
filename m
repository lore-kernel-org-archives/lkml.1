Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYDWPks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYDWPks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 11:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYDWPkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 11:40:40 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:44200 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYDWPkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 11:40:39 -0400
Date: Wed, 23 Apr 2008 11:40:38 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Will Newton <will.newton@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
Message-ID: <20080423154038.GL19802@phobos.i.cabal.ca>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <20080422081211.e85989ec.randy.dunlap@oracle.com> <87a5b0800804220816y72a7f4f9gec2111df08a1a57f@mail.gmail.com> <20080422152426.GG19802@phobos.i.cabal.ca> <87a5b0800804220834q4d6daec1x4146d211115ab5c@mail.gmail.com> <20080422153849.GH19802@phobos.i.cabal.ca> <87a5b0800804230736k340e7fe9mffbd72b5b8164015@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5b0800804230736k340e7fe9mffbd72b5b8164015@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 03:36:23PM +0100, Will Newton wrote:
> +config ARCH_HAS_SYS_SYSFS
> +	bool
> +	default y
> +
>  source "init/Kconfig"
> 

Sorry, I meant something more like

config ARCH_HAS_SYS_SYSFS
	def_bool !BLACKFIN
	help
	  Obsolete sys_sysfs syscall

in init/Kconfig

But, it's your patch, you can do it however you like. :)

regards, Kyle
