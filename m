Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYAGVF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYAGVF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYAGVFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:05:18 -0500
Received: from ozlabs.org ([203.10.76.45]:33249 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbYAGVFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:05:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 1/2] show being-loaded/being-unloaded indicator for modules
Date: Tue, 8 Jan 2008 08:05:00 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: devzero@web.de, linux-kernel@vger.kernel.org
References: <90564384@web.de> <20080107062116.0aa37438@laptopd505.fenrus.org>
In-Reply-To: <20080107062116.0aa37438@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801080805.00639.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 01:21:16 Arjan van de Ven wrote:
> On Mon, 07 Jan 2008 11:09:23 +0100
>
> devzero@web.de wrote:
> > this looks very useful!
> >
> > >Unfortunatly, it's not always easy to see directly
> > >which module is being loaded/unloaded from the oops itself.
> >
> > no wonder, as most modules seem to be very quiet on on load/unload.
> >
> >
> >
> >
> > but i wonder if some mandatory "print a message on init/exit"
> > wouldn`t give a benefit to admins or end-users, too. sure this would
> > additionally clutter up syslog, but it would add transparency.
>
> Regardless of the usefulness, really, if this would be mandatory for all
> modules, it should be done in the module loader itself....
> But I'm not entirely convinced how useful that is to do always, although I
> can see the point of having it as debug option, similar to the initcall
> debug stuff...

We could overload initcall_debug for this if we wanted to be consistant.  But 
I'm just not sure it'd be clear when to turn it on...

Rusty.
