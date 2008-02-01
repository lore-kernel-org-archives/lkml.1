Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbYBAXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbYBAXCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYBAXCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:02:08 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:42295 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbYBAXCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:02:07 -0500
Date: Sat, 2 Feb 2008 00:02:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [scsi bug] spurious build failures in aic7xxx
Message-ID: <20080201230210.GA18006@uranus.ravnborg.org>
References: <20080201225056.GA18302@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201225056.GA18302@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 11:50:56PM +0100, Ingo Molnar wrote:
> 
> i'm getting spurious build failures with latest -git:
> 
> In file included from drivers/scsi/aic7xxx/aic7xxx_proc.c:44:
> drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_pause_bug_fix':
> drivers/scsi/aic7xxx/aic7xxx_inline.h:66: error: 'CCSCBCTL' undeclared (first use in this function)
> drivers/scsi/aic7xxx/aic7xxx_inline.h:66: error: (Each undeclared 
> identifier is reported only once
> drivers/scsi/aic7xxx/aic7xxx_inline.h:66: error: for each function it 
> appears in.)
> drivers/scsi/aic7xxx/aic7xxx_inline.h: In function 'ahc_update_residual':
> 
> BUT, if i redo the build, it now builds. It's probably some generated 
> file ordering problem?

Most likely:
93a38fa2dd83fcaf65b2327fff65e364472388f9 [SCSI] aic7xxx: fix firmware build
I will take a look during the weekend.

One day I get this Makefile fixed properly (I hope).

	Sam
