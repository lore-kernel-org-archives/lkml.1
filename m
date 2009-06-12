Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZFLLLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZFLLLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZFLLK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:10:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39708 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbZFLLK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:10:59 -0400
Date: Fri, 12 Jun 2009 13:10:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Magnus Damm <damm@igel.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Sergio Luis <sergio@larces.uece.br>,
       Lauro Salmito <laurosalmito@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [PATCH 15/19] Driver Core: Rework platform suspend/resume,
	print warning
Message-ID: <20090612111051.GO18682@elf.ucw.cz>
References: <0615007ad8090a890586d530b5d3bb98da566014.1244752872.git.rjw@sisk.pl> <S4AoGnG.A.YH.yhYMKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <S4AoGnG.A.YH.yhYMKB@chimera>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 22:40:30, Rafael J. Wysocki wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> This patch reworks the platform driver code for legacy
> suspend and resume to avoid installing callbacks in
> struct device_driver. A warning is also added telling
> users to update the platform driver to use dev_pm_ops.
> 
> The functions platform_legacy_suspend()/resume() directly
> call suspend and resume callbacks in struct platform_driver
> instead of wrapping things in platform_drv_suspend()/resume().
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
