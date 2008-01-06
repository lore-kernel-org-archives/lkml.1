Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbYAFNzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbYAFNzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYAFNz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:55:28 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58300 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbYAFNz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:55:27 -0500
Date: Sun, 6 Jan 2008 14:55:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Al Boldi <a1426z@gawab.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
Message-ID: <20080106135528.GB3139@uranus.ravnborg.org>
References: <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist> <4780C728.1030806@s5r6.in-berlin.de> <20080106123728.GD2082@does.not.exist> <4780D3E5.20908@s5r6.in-berlin.de> <20080106133854.GH2082@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080106133854.GH2082@does.not.exist>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> You miss the fundamental point:

Adrian - it is you that miss the important piont in this discussion.

We have two simple options:
1) Allow the user to define non-valid configurations
2) And the opposite

And we want to define only valid configurations which is why we
with the present select behavious cannot just do "select USB",
becasue we may end up with USB selected but not what USB depends on.

And duplicating the dependencies of USB in all places where we
select USB is not a scalable solution.

So until we have select fixed - do not misue it.

	Sam
