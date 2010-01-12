Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907Ab0ALOYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0ALOYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 09:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789Ab0ALOYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 09:24:13 -0500
Received: from trinity.fluff.org ([89.16.178.74]:33618 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab0ALOYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 09:24:12 -0500
Date: Tue, 12 Jan 2010 14:24:04 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Francesco VIRLINZI <francesco.virlinzi@st.com>,
       Jeremy Kerr <jeremy.kerr@canonical.com>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/7 v2] Add a common struct clk
Message-ID: <20100112142404.GD18532@trinity.fluff.org>
References: <1263279511.160551.332624337260.1.gpush@pororo> <4B4C376C.6080705@st.com> <20100112090149.GB26435@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112090149.GB26435@n2100.arm.linux.org.uk>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 09:01:49AM +0000, Russell King - ARM Linux wrote:
> On Tue, Jan 12, 2010 at 09:48:44AM +0100, Francesco VIRLINZI wrote:
> > Hi Jeremy
> > In November I already sent a proposal on
> >  a generic linux clk framework.
> > On that I would suggest:
> >
> >>
> >> +struct clk {
> >> +	const struct clk_operations *ops;
> >>    
> >            spinlock_t lock;
> >            const char *name;
> >            int id;
> 
> Name and ID are totally pointless, unless you insist on using the clk
> API in the wrong way (like S3C does.)

I do intend to change the clock lookup on the Samsung series, but we're
currently in the process of trying to do a whole pile of work on not
only adding new SoCs but also cleaning up the existing support and making
a whole pile of code common to all the Samsung SoC family.

I never got the time to go throughly through Francesco's clock framework
but it seemed rathe rcomplicated for our current requirements and also
had a whole pile of style problems that made it really difficult to read.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

