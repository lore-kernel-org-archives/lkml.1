Return-Path: <linux-kernel-owner+w=401wt.eu-S933878AbZFLKhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878AbZFLKhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764161AbZFLKhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:37:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58807 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764152AbZFLKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:37:35 -0400
Date: Fri, 12 Jun 2009 12:37:28 +0200
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
Subject: Re: [PATCH 01/19] PM: Warn if interrupts are enabled during
	suspend-resume of sysdevs
Message-ID: <20090612103728.GE18682@elf.ucw.cz>
References: <0615007ad8090a890586d530b5d3bb98da566014.1244752872.git.rjw@sisk.pl> <S4AoGnG.A.D7H.mZXMKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <S4AoGnG.A.D7H.mZXMKB@chimera>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 21:41:15, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Sysdevs have to be suspended and resumed with interrupts disabled and
> things usually break in a way that's difficult to debug if one of
> sysdev drivers enables interrupts by mistake during suspend or
> resume.  Add extra checks that will generate warnings in such cases.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
