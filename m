Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYIWQLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYIWQLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYIWQLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:11:14 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56830 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYIWQLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:11:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:
	content-transfer-encoding:x-gmailtapped-by;
	b=BRJXD8UAS/lrQfRUxq/P2rUoYHH/q1zXO+Ph6dJlqykOJYd0XaGgnH0SGvkeT2VQX
	odbH9nyhkotwInih6CvDw==
Subject: Re: [PATCH 2.6.27-rc5 re-resubmit] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080923135917.GA285@tv-sign.ru>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	 <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu>
	 <1221502142.19012.35.camel@bobble.smo.corp.google.com>
	 <20080916084143.GC17287@elte.hu>
	 <1221678187.13420.17.camel@bobble.smo.corp.google.com>
	 <20080918102353.GD20967@elte.hu>
	 <1222114936.21579.20.camel@bobble.smo.corp.google.com>
	 <20080923114033.GB14840@elte.hu>  <20080923135917.GA285@tv-sign.ru>
Content-Type: text/plain
Organization: Google, Inc.
Date: Tue, 23 Sep 2008 09:09:57 -0700
Message-Id: <1222186197.1408.2.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 17:59 +0400, Oleg Nesterov wrote:
> Confused. Unless I misread the patch, tgtimes->totals can be NULL
> on UP too?

Yep.  I've had about four different irons in the fire over the last few
days and I think because of that I ended up giving this less attention
than I should have.  I'll beat on this some more and reroll the patch in
the next day or so.

I'll also provide the delta patch as Ingo requested.

Sorry, folks.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

