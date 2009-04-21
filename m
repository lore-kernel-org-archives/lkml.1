Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZDUSio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZDUSio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757890AbZDUSf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:35:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:54879 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758022AbZDUSf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:35:56 -0400
Date: Tue, 21 Apr 2009 18:34:24 +0000
From: Chris Wright <chrisw@sous-sol.org>
To: Andrea Righi <righi.andrea@gmail.com>, Pavel Roskin <proski@gnu.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [BISECTED] x11 fbdev on intelfb hangs hard after
	66c1ca019078220dc1bf968f2bb18421100ef147
Message-ID: <20090421183424.GE22386@hera.kernel.org>
References: <1239314524.7390.14.camel@mj> <20090410081428.GA5595@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410081428.GA5595@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 18:34:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrea Righi (righi.andrea@gmail.com) wrote:
> Thanks for reporting Pavel. I agree to revert 66c1ca ASAP.

Rather than dropping from -stable queue, looks like we should be adding:
513adb58685615b0b1d47a3f0d40f5352beff189 "fbdev: fix info->lock deadlock
in fbcon_event_notify()"? 

thanks,
-chris
