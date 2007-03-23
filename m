Return-Path: <linux-kernel-owner+w=401wt.eu-S2992566AbXCWUsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992566AbXCWUsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992567AbXCWUsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:48:14 -0400
Received: from websrv.werbeagentur-aufwind.de ([88.198.253.206]:51462 "EHLO
	websrv2.werbeagentur-aufwind.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992566AbXCWUsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:48:13 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Mar 2007 16:48:13 EDT
Message-ID: <46043B77.60703@christoph-maier.de>
Date: Fri, 23 Mar 2007 21:41:27 +0100
From: Christoph Maier <lists@christoph-maier.de>
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: jckn@gmx.net
CC: linux-kernel@vger.kernel.org
Subject: Re: race condition in dm-crypt?
References: <20070323170535.GA3057@hejre.minidns.net>
In-Reply-To: <20070323170535.GA3057@hejre.minidns.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan C. Nordholz wrote:
> I think I'm experiencing a race condition: Irregularly my kernel runs
> into an Oops when it tries to initialize my crypt containers.

FYI, there are similiar reports on the net, going as far back as May 2006:
http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/1636 
is the oldest one I could find.

Bugzilla entry: http://bugzilla.kernel.org/show_bug.cgi?id=7388

I, too, ran into the bug and failed to reproduce it. However, it might 
be worth knowing that the system went to 100% iowait afterwards.

Regards, Christoph Maier

