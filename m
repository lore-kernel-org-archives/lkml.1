Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYLPQSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYLPQSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756238AbYLPQSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:18:24 -0500
Received: from main.gmane.org ([80.91.229.2]:46276 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbYLPQSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:18:23 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
Date: Tue, 16 Dec 2008 16:18:13 +0000 (UTC)
Message-ID: <gi8kc5$m5f$6@ger.gmane.org>
References: <gi247o$iog$1@ger.gmane.org> <200812161625.37318.rjw@sisk.pl>
	<gi8jf1$m5f$5@ger.gmane.org> <200812161713.08451.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: d193-213-184.home3.cgocable.net
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-acpi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 17:13:08 +0100, Rafael J. Wysocki wrote:
> 
> Hm, this really isn't reasonable.

Many people agree with you.  :-)  There is a long bug open with ubuntu to 
restore this s2ram.  They seem to be ignoring it though.

> s2both saves the image, which takes
> quite a lot of time, while s2ram doesn't.

Indeed.
 
> You can compile s2ram from sources, it's not too difficult.

Yeah.  I will probably just grab the debian package and dpkg-buildpackage 
it on my Ubuntu system.
 
> Hm.  Is that all loaded when you boot with init=/bin/bash (by which I
> mean the minimal config)?

It sure is.  Most assuredly by the initrd.  Debian/Ubuntu systems seem to 
put everything but the kitchen sink into their initrds.  Which on the one 
hand makes them pretty portable and resilient, but on the other, yes, 
bloated.

b.


