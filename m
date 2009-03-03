Return-Path: <linux-kernel-owner+w=401wt.eu-S1761337AbZCCWMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337AbZCCWMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbZCCWHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:07:41 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34177 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759441AbZCCWHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:07:34 -0500
Subject: Re: [Bug #12762] Disk errors loop forever in 2.6.29
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Sitsofe Wheeler <sitsofe@yahoo.com>
In-Reply-To: <SLCXkuHtxAO.A.MVC.EVarJB@chimera>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
	 <SLCXkuHtxAO.A.MVC.EVarJB@chimera>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 16:07:29 -0600
Message-Id: <1236118049.24019.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 20:25 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12762
> Subject		: Disk errors loop forever in 2.6.29
> Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
> Date		: 2009-02-19 13:53 (13 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b60af5b0adf0da24c673598c8d3fb4d4189a15ce
> References	: http://marc.info/?l=linux-kernel&m=123505185407604&w=4
> Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
> Patch		: http://marc.info/?l=linux-kernel&m=123508030726900&w=4

In theory, the fix should be upstream here:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=126c098296c8f96cf7f6ca0fdb47265ac7994f00

(not in a released -rc yet, but should be in -rc7).

James


