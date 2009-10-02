Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZJBTq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZJBTq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 15:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbZJBTq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 15:46:57 -0400
Received: from ppp-145-20.adsl.restena.lu ([158.64.145.20]:57139 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbZJBTq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 15:46:57 -0400
Date: Fri, 2 Oct 2009 21:36:30 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13942] Troubles with AoE and uninitialized object
Message-ID: <20091002213630.42c73909@neptune.home>
In-Reply-To: <COE24pZSBH.A.t9C.XOTxKB@chimera>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	<COE24pZSBH.A.t9C.XOTxKB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 October 2009 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still
> should be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13942
> Subject	: Troubles with AoE and uninitialized object
> Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
> Date		: 2009-08-04 10:12 (59 days old)
> References	: http://marc.info/?l=linux-kernel&m=124938117104811&w=4

This should have been fixed with commits:

  18d8217bc441630c3c5ec7416c5a65c69e8a0979
  aoe: end barrier bios with EOPNOTSUPP

  This addresses the trace on unmounting XFS


  7135a71b19be1faf48b7148d77844d03bc0717d6
  aoe: allocate unused request_queue for sysfs

  This addresses the NULL kobject part


I think the second one made it into 2.6.31 but first one didn't,
please double-check! I've not seen them on stable though (which might
be worth especially for the first one)

Bruno
