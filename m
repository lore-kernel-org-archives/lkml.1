Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZBTWha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZBTWha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZBTWhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:37:22 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54781 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbZBTWhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:37:21 -0500
To: richard@rsk.demon.co.uk
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
Subject: Re: linux-next-20090220: insmod: -1 Invalid module format
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200902202229.BDD18292.SFOLMOVFOtFJQH@I-love.SAKURA.ne.jp>
	<499EC428.7080901@rsk.demon.co.uk>
In-Reply-To: <499EC428.7080901@rsk.demon.co.uk>
Message-Id: <200902210737.JFC00066.JFLMOHOOSFFQVt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 21 Feb 2009 07:37:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard kennedy wrote:
> Tetsuo Handa wrote:
> > I can't load kernel module for linux-next-200902{18,19,20} .
> > linux-next-20090217 was OK.
> 
> I've just had the same problem.
> 
> It seems to be CONFIG_MODVERSIONS that causes this problem. I unset it
> in my config & everything works now. I see that you've got it set as
> well, so you could try removing it.
> 
Changing CONFIG_MODVERSIONS to N solved the problem.

Thank you.
