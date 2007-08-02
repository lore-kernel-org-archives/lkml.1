Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbXHBRey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbXHBRey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbXHBRep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:34:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758131AbXHBReo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:34:44 -0400
Message-ID: <46B2158D.4000709@redhat.com>
Date: Thu, 02 Aug 2007 13:34:05 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mark Tiefenbruck <mark@fluxbox.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Dell Inspiron 1501 fails to boot in 2.6.21+
References: <c96265a60707201937t39f9b69ep48e76ed61ce1044e@mail.gmail.com>
In-Reply-To: <c96265a60707201937t39f9b69ep48e76ed61ce1044e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2007 10:37 PM, Mark Tiefenbruck wrote:
> I'd appreciate any help on getting this report sent to the appropriate
> list and, of course, getting this fixed. I don't know what's useful,
> so you're getting everything. This will be a very long e-mail.
> 
> My new laptop won't boot with kernel versions 2.6.21 or 2.6.22 . No
> oops. No panic. It just stops printing messages. Maybe it would
> eventually continue if I wait long enough, but it's unacceptable
> either way. I include below the contents of dmesg for a working kernel
> up to the point where it halts. I'm also including what it usually
> does for a few lines after that point.
> 

Does it continue booting if you keep pressing the Ctrl key repeatedly?

I have one that does, with kernel 2.6.23-rc1-git9 -- otherwise it just
sits there indefinitely. As soon as I press a key it continues. This is
even with 'nohz=off highres=off'.

Using 'nolapic_timer' (by itself) fixes it, though.

