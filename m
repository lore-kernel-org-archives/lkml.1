Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbZCTRaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbZCTRaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 13:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbZCTR3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 13:29:52 -0400
Received: from kroah.org ([198.145.64.141]:33283 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756594AbZCTR3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 13:29:51 -0400
Date: Fri, 20 Mar 2009 10:25:02 -0700
From: Greg KH <greg@kroah.com>
To: Daniel =?iso-8859-1?Q?Kr=FCger?= 
	<daniel.krueger@systec-electronic.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       Michael Olbrich <mol@pengutronix.de>, Wolfram Sang <wsa@pengutronix.de>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The Linux Staging tree, what it is and is not.
Message-ID: <20090320172502.GA14647@kroah.com>
References: <20090318183232.GA11594@kroah.com> <20090320005808.GM5367@pengutronix.de> <20090320024816.GA20213@kroah.com> <49C35515.8050808@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C35515.8050808@systec-electronic.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 09:34:29AM +0100, Daniel Krüger wrote:
> Greg KH schrieb:
>> On Fri, Mar 20, 2009 at 01:58:08AM +0100, Robert Schwebel wrote:
>>> Greg,
>>>
>>> On Wed, Mar 18, 2009 at 11:32:32AM -0700, Greg KH wrote:
>>>> If anyone has any questions that this summary doesn't answer, please let 
>>>> me
>>>> know.
>>> Let me take this as an opportunity to discuss the epl (Ethernet
>>> Powerlink) driver in staging. Taken aside the eye-cancer thing while
>>> looking at the code (this could be fixed in the staging model), I
>>> suppose the whole design is questionable.
>> Sure it's questionable, and it's horrid code, but it is being used by
>> people and is the only public implementation of EPL on Linux that I can
>> find.
>
> BTW, the implementation does not follow the kernel style guide, because our 
> company has its own code style guide. But what is that you don't like?

It's not an issue of "not liking" it, it just doesn't match the kernel
style guide.

I'll go make up a patch today to fix the layout and lots of the
structure issues of the code to match our rules, so that people can then
start working on the real functionality much easier.

thanks,

greg k-h
