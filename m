Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390AbZAZKxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbZAZKxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 05:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZAZKxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 05:53:25 -0500
Received: from twin.jikos.cz ([213.151.79.26]:55017 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZAZKxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 05:53:25 -0500
Date: Mon, 26 Jan 2009 11:52:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Johannes Berg <johannes@sipsolutions.net>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Samuel Ortiz <sameo@openedhand.com>
Subject: Re: since 2.6.29-rc: apple infrared keeps system awake?
In-Reply-To: <1232635779.4224.12.camel@johannes.local>
Message-ID: <alpine.LRH.1.10.0901261151320.26411@twin.jikos.cz>
References: <1232635779.4224.12.camel@johannes.local>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009, Johannes Berg wrote:

> Ever since 2.6.29-rc, I see this in powertop on my macbook5,1:
> Top causes for wakeups:
>   24.1% ( 27.8)   USB device usb1 : OHCI Host Controller (Linux 2.6.29-rc2-wl-di
>   21.5% ( 24.8)       <interrupt> : ohci_hcd:usb1 
>   14.5% ( 16.7)   USB device  1-5 : IR Receiver (Apple Computer, Inc.) 
> which is way way more than what it used to be, I never saw the IR 
> receiver before. I could bisect, but wondered if somebody had seen this 
> before?

What driver is bound to this device? (what is the product ID?).

-- 
Jiri Kosina
SUSE Labs

