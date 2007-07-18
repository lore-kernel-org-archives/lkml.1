Return-Path: <linux-kernel-owner+w=401wt.eu-S934963AbXGRXJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934963AbXGRXJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757115AbXGRXJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:09:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754540AbXGRXJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:09:08 -0400
Date: Wed, 18 Jul 2007 16:08:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: linux-kernel@vger.kernel.org, shai@scalex86.org
Subject: Re: [patch] Change softlockup trigger limit using a kernel
 parameter
Message-Id: <20070718160858.75865461.akpm@linux-foundation.org>
In-Reply-To: <20070716222650.GA5947@localdomain>
References: <20070716222650.GA5947@localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 15:26:50 -0700
Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> Kernel warns of softlockups if the softlockup thread is not able to run
> on a CPU for 10s.  It is useful to lower the softlockup warning
> threshold in testing environments to catch potential lockups early.
> Following patch adds a kernel parameter 'softlockup_lim' to control
> the softlockup threshold.
> 

Why not make it tunable at runtime?

> 
> Control the trigger limit for softlockup warnings.  This is useful for
> debugging softlockups, by lowering the softlockup_lim to identify
> possible softlockups earlier.

Please check your patches with scripts/checkpatch.pl.
