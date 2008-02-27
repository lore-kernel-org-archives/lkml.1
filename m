Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYB0P6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYB0P6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYB0P6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:58:35 -0500
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:25352 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490AbYB0P6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:58:35 -0500
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.25-rc3 regression] sysctl table check failed: /kernel/vsyscall64
Date: Wed, 27 Feb 2008 16:57:43 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200802271609.48450.elendil@planet.nl> <20080227151818.GA23138@elte.hu>
In-Reply-To: <20080227151818.GA23138@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271657.43704.elendil@planet.nl>
X-OriginalArrivalTime: 27 Feb 2008 15:57:44.0314 (UTC) FILETIME=[7D68F5A0:01C87959]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008, Ingo Molnar wrote:
> * Frans Pop <elendil@planet.nl> wrote:
> > Just tried 2.6.25-rc3 and got the error below. Boot continued
> > normally. Error was not present in rc2.
>
> fix is already in x86.git#testing:
>   http://people.redhat.com/mingo/x86.git/README

Thanks. Can confirm that cherry-pick of this fix from that tree fixed it:

commit ed19f1cd69aa82619e2def4e11dfece8f9fe7e31
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Feb 27 09:39:52 2008 +0100

    x86: restore vsyscall64 prochandler
