Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbYFHQri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbYFHQri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 12:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYFHQra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 12:47:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41998 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724AbYFHQr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 12:47:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #10616] Horrendous Audio Stutter - current git
Date: Sun, 8 Jun 2008 18:48:24 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, parag.warudkar@gmail.com,
       peterz@infradead.org
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.oVF.E6vSIB@albercik> <200806080035.00796.elendil@planet.nl>
In-Reply-To: <200806080035.00796.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081848.24699.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 of June 2008, Frans Pop wrote:
> Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> 
> This issue was traced to FAIR_GROUP_SCHED, which is no longer present 
> in -rc5 as the patches that introduced it have been reverted:
> 
> Commit: f9305d4a0968201b2818dbed0dc8cb0d4ee7aeb3
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu May 29 11:23:17 2008 +0200
> 
>     revert ("sched: fair: weight calculations")
> 
> commit 6363ca57c76b7b83639ca8c83fc285fa26a7880e
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu May 29 11:28:57 2008 +0200
> 
>     revert ("sched: fair-group: SMP-nice for group scheduling")
> 
> Therefore this issue can be removed from the regressions list.

Thanks, I've closed the bug.

Rafael
