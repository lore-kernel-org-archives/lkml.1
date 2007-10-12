Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbXJLOwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbXJLOwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbXJLOwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:52:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:37599 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbXJLOwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=Q7FCP6yJSb04eFWC/RJhcBE+pjyELqjBiEYKwAelmgLvNPOdChSrC6WTifzjT2p3g8USvQsLoWo4lCzR0yZ4aW+gDQdOq/pLtN+JyhSNLPnVWOJ8pw2dspfQYVLKOW/ooyXnahSjAkvxXAL/yT7pV6+TS82UqCcr1WrqJ6ycpNI=
Date: Fri, 12 Oct 2007 16:46:44 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Jan Blunck <jblunck@suse.de>
Cc: mingo@redhat.com, Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: kernel NULL pointer dereference in check_spread+0x0/0x26
Message-ID: <20071012144644.GA17456@slug>
References: <20071012124054.GD8471@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012124054.GD8471@hasse.suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 02:40:54PM +0200, Jan Blunck wrote:
> This is with 2.6.23-mm1 and allmodconfig.
This generates a .config with CONFIG_SCHED_DEBUG=y and
CONFIG_FAIR_GROUP_SCHED=n (The latter causes parent_entity to return
NULL).
Does setting CONFIG_FAIR_GROUP_SCHED=y help?

Regards,
Frederik
