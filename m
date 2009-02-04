Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbZBDP7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbZBDP7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZBDP66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:58:58 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:56721 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZBDP65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:58:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XHxYwOdGUdIhQIYhHdDAj1gYGBm/PTbWB2PiFAUnX9Grw23Hj4xGw3A2ITSKyoMXdo
         K0rToZr0QGjkkG1ugXURybrQUG5OQz2jR5VwBS2Td65cXIOI2Wug5AR0uEJyuk09bffL
         o9+WJh6arygH510N8rhgo/Y31GE0TNCMn8pyc=
MIME-Version: 1.0
In-Reply-To: <pWZw1SZjMCH.A.NpF.OvYiJB@chimera>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.NpF.OvYiJB@chimera>
Date: Wed, 4 Feb 2009 16:58:55 +0100
Message-ID: <81b0412b0902040758s43ba058ava7470213b6d74a85@mail.gmail.com>
Subject: Re: [Bug #12518] BUG: using smp_processor_id() in preemptible 
	[00000000] code: dellWirelessCtl/...
From: Alex Riesen <raa.lkml@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alex Riesen <fork0@users.sf.net>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/4 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>

I confirm the problem fixed with the patch in the bugs discussion.

>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12518
> Subject         : BUG: using smp_processor_id() in preemptible [00000000] code:  dellWirelessCtl/...
> Submitter       : Alex Riesen <fork0@users.sf.net>
> Date            : 2009-01-21 14:21 (15 days old)
>
