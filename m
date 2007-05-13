Return-Path: <linux-kernel-owner+w=401wt.eu-S934446AbXEMQ2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbXEMQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbXEMQ2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:28:01 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:34248 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757862AbXEMQ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:28:00 -0400
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
From: James Bottomley <James.Bottomley@SteelEye.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705131216440.27468@localhost.localdomain>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0705131216440.27468@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 13 May 2007 11:27:50 -0500
Message-Id: <1179073670.3723.48.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 12:20 -0400, Robert P. J. Day wrote:
> since this thread looks like it's going to get away from me in a
> hurry :-), my only point in asking was to point out that that lone
> module was the only thing preventing the build from being module-free.
> 
> i'm not saying that that's *necessarily* a good thing, but it just
> strikes me as odd that, out of all of the possible modules that might
> be selected in a default config for x86, this was the *only* one that
> was picked.
> 
> i just think it's a bit weird, that's all.

It's designed on the predicate that people who want to be module free
will actually set CONFIG_MODULE=n.

If you set CONFIG_MODULE=y and build SCSI we assume you could have a
SCSI driver module at some point, which would necessitate the wait scan
module.

James


