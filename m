Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbYHPNt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbYHPNt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 09:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYHPNtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 09:49:51 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:2866 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYHPNtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 09:49:50 -0400
Date: Sat, 16 Aug 2008 16:48:09 +0300
From: Martin Michlmayr <tbm@cyrius.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Avuton Olrich <avuton@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: s2disk: system powers up again after power off
Message-ID: <20080816134809.GC2758@deprecation.cyrius.com>
References: <20080715124733.GA4111@deprecation.cyrius.com> <200807152224.19559.rjw@sisk.pl> <20080716123611.GA2532@deprecation.cyrius.com> <200807161737.12370.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807161737.12370.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [2008-07-16 17:37]:
> > > Please try to put "shutdown method = shutdown" into the s2disk's configuration
> > > file and see what happens in that case.
> > Yep, this work.
> 
> This is a workaround, though.
> 
> Can you check if the problem is present in linux-next, please?

I finally got a chance to test 2.6.27-rc2 and confirm that my laptop
correctly powers off with "shutdown method = platform now".

Do you have any idea which patch might have fixed this?  It would be
nice to include it in Debian's 2.6.26 kernel.
-- 
Martin Michlmayr
http://www.cyrius.com/
