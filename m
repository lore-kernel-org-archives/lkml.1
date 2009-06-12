Return-Path: <linux-kernel-owner+w=401wt.eu-S1763463AbZFLKvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763463AbZFLKvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbZFLKvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:51:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56472 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbZFLKvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:51:35 -0400
Date: Fri, 12 Jun 2009 12:51:26 +0200
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
Subject: Re: [PATCH 09/19] PM: Rename device_power_down/up()
Message-ID: <20090612105126.GJ18682@elf.ucw.cz>
References: <0615007ad8090a890586d530b5d3bb98da566014.1244752872.git.rjw@sisk.pl> <S4AoGnG.A.cG.6eYMKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <S4AoGnG.A.cG.6eYMKB@chimera>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 22:37:28, Rafael J. Wysocki wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> Rename the functions performing "_noirq" dev_pm_ops
> operations from device_power_down() and device_power_up()
> to device_suspend_noirq() and device_resume_noirq().
> 
> The new function names are chosen to show that the functions
> are responsible for calling the _noirq() versions to finalize
> the suspend/resume operation. The current function names do
> not perform power down/up anymore so the names may be misleading.
> 
> Global function renames:
> - device_power_down() -> device_suspend_noirq()
> - device_power_up() -> device_resume_noirq()
> 
> Static function renames:
> - suspend_device_noirq() -> __device_suspend_noirq()
> - resume_device_noirq() -> __device_resume_noirq()
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Acked-by: Len Brown <lenb@kernel.org>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
