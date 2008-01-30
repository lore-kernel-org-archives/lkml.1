Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbYA3WA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbYA3WA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYA3WAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:00:06 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:59959 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYA3WAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:00:04 -0500
Date: Wed, 30 Jan 2008 23:00:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, davem@davemloft.net,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] scsi/qlogicpti.c section fixes
Message-ID: <20080130220006.GA27094@uranus.ravnborg.org>
References: <20080130200336.GN29368@does.not.exist> <1201726817.3292.84.camel@localhost.localdomain> <20080130212011.GA26621@uranus.ravnborg.org> <1201729295.3292.94.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201729295.3292.94.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm just reflecting that all of the
> problems would go away and we'd save thousands of person hours on the
> infrastructure and bug fixing if we simply #defined most of the
> sectional annotations to be nops.

So far I have only seen three persons being really active in fixing the
section mismatch bugs. And thats Randy, Adrian and myself.
Granted a few other have done some sporadic efforts in their
area of interest but nothing covering the tree as a whole.
And most isssues are easy fixable - I would estimate less than
half an hour in average for the fixes Adrian posted today.
There are some tricky corners that are dfficult to deal with
but I have not seen these occur in drivers.
It is mostly when we mix assembler and C plus
some of the core functionality.
The hotplug cpu stuff for example look scary and here
I may try to road you propose but for the hotplug stuff
I think it is worth it.

	Sam
