Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYBQRUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYBQRUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYBQRUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:20:06 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57847 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbYBQRUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:20:05 -0500
Date: Sun, 17 Feb 2008 18:20:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 14/27] hwmon: fix section mismatch in coretemp
Message-ID: <20080217172012.GA13440@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org> <1203250984-11285-14-git-send-email-sam@ravnborg.org> <20080217170708.GB2916@jupiter.solarsys.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217170708.GB2916@jupiter.solarsys.private>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This rings a bell... hmmm, commit 59a35bafb223bbb0553ba1a3bb9280bda668a8d8.
> AFAICT the warning is a false positive, but whatever.

Yes it is - the __refdata is there only to silence modpost.

> 
> Applied to hwmon-2.6.git/testing, thanks.

Thanks,

	Sam
