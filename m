Return-Path: <linux-kernel-owner+w=401wt.eu-S964792AbXBYKoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbXBYKoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbXBYKoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:44:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40364 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964795AbXBYKoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:44:01 -0500
Date: Sun, 25 Feb 2007 11:43:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
       ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Aneesh Kumar <aneesh.kumar@gmail.com>
Subject: Re: [RFC][PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070225104354.GH2045@elf.ucw.cz>
References: <200702231116.23607.rjw@sisk.pl> <200702231118.07629.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702231118.07629.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-02-23 11:18:06, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The reading of PF_BORROWED_MM in is_user_space() without task_lock() is racy.
> Fix it.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
