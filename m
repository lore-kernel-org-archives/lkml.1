Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbXLDWEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbXLDWEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXLDWDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:03:54 -0500
Received: from THUNK.ORG ([69.25.196.29]:57958 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXLDWDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:03:54 -0500
Date: Tue, 4 Dec 2007 17:03:16 -0500
From: Theodore Tso <tytso@mit.edu>
To: Mike McGrath <mmcgrath@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>,
       Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204220316.GF7259@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Mike McGrath <mmcgrath@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>,
	Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com> <20071204165502.0a8f695e@the-village.bc.nu> <20071204180237.GU19691@waste.org> <20071204195021.GB7259@thunk.org> <20071204204036.484f11ac@the-village.bc.nu> <4755BD0C.2060808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4755BD0C.2060808@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 02:48:12PM -0600, Mike McGrath wrote:
> Alan Cox wrote:
>>> Here's the top 5:
>>>
>>>    266 28caf2c3-9766-4fe1-9e4c-d6b0ba8a0132
>>>    336 810e7126-1c69-4aff-b8b1-9db0fa8aa15a
>>>    402 c8dbb9d3-a9bd-4ba6-b92e-4a294ba5a95f
>>>    884 06e84493-e024-44b1-9b32-32d78af04039
>>>    931 e2b67e1d-e325-4740-b938-795addb45280
>>>
>>> The left number is times this month someone has submitted a profile with
>>> that UUID.  If we take the last one as an example has come from over 800
>>> IP's in the last 20 days.  It seems very unlikely that one person would
>>> find his way to 800 different IP's this month.  Let me know if you'd
>>> like more.
>>>     
> Background - Smolt runs this during its install:
>
> /bin/cat /proc/sys/kernel/random/uuid > /etc/sysconfig/hw-uuid
>
> For most users this would be run by the RPM %post scripts during install 
> from anaconda. For some reason there are some UUID's (like those listed 
> above) that come up more often then it seems they should if they are truly 
> random.

Would this be by any chance using kickstart where there is no user
interaction, and no way of gathering entropy during the install process?
The random number generator isn't *magic* you know....

	     	    	   	     	     	    - Ted
