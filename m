Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbZBENlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbZBENlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 08:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZBENkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 08:40:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38652 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbZBENkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 08:40:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090107190652.GA20311@us.ibm.com>
References: <20090107190652.GA20311@us.ibm.com> <200901060514.n065E462074929@www262.sakura.ne.jp> <20090106155829.GA9773@us.ibm.com> <49639039.4060708@cs.columbia.edu> <1231267532.9746.116.camel@localhost.localdomain> <200901070634.n076YCxF061022@www262.sakura.ne.jp>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       sds@tycho.nsa.gov, spotter@cs.columbia.edu,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add in_execve flag into task_struct.
Date: Thu, 05 Feb 2009 13:40:35 +0000
Message-ID: <2690.1233841235@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> It's ugly, you can't get me to say it isn't ugly :), and it sets a scary
> bad precedent.  But if David insists (in a reply to this msg) that this
> flag really is tops, then just ignore me.  Anyway my point wasn't to
> block the patch but to raise discussion (so someone else could decide to
> block it :) on both the flag and security implications of these
> semantics.

I think it's probably the best way to support Tomoyo's security model without
reworking a chunk of execve().

David
