Return-Path: <linux-kernel-owner+w=401wt.eu-S1762347AbZFLLDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762347AbZFLLDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbZFLLDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:03:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41142 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbZFLLDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:03:39 -0400
Date: Fri, 12 Jun 2009 13:03:32 +0200
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
Subject: Re: [PATCH 14/19] PM: Remove device_type suspend()/resume()
Message-ID: <20090612110332.GM18682@elf.ucw.cz>
References: <0615007ad8090a890586d530b5d3bb98da566014.1244752872.git.rjw@sisk.pl> <S4AoGnG.A.OH.VhYMKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <S4AoGnG.A.OH.VhYMKB@chimera>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 22:40:00, Rafael J. Wysocki wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> This patch removes the legacy callbacks ->suspend() and
> ->resume() from struct device_type. These callbacks seem
> unused, and new code should instead make use of struct
> dev_pm_ops.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
