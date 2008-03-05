Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYCEWcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYCEWcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYCEWbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:31:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:45541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762245AbYCEWbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:31:46 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
Date: Wed, 5 Mar 2008 23:31:42 +0100
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz> <20080305093923.GA2049@atrey.karlin.mff.cuni.cz> <200803052312.37996.rjw@sisk.pl>
In-Reply-To: <200803052312.37996.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803052331.42193.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just commenting on the subject. The 34TB are not an over/underflow. x86-64
simply has so much address space reserved for vmalloc. It doesn't mean of course 
that that much could be actually allocated in real memory.

-Andi
