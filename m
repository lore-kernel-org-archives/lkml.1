Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbXKRPFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbXKRPFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 10:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXKRPFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 10:05:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34735 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbXKRPFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 10:05:42 -0500
From: "=?utf-8?q?Rafa=C5=82_J=2E?= Wysocki" <rjwysocki@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
Date: Sun, 18 Nov 2007 16:23:19 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0711171649100.7748-100000@netrider.rowland.org> <200711181603.26522.rjw@sisk.pl> <474050EC.5080507@gmail.com>
In-Reply-To: <474050EC.5080507@gmail.com>
Organization: SiSK
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711181623.20029.rjwysocki@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 of November 2007, Jiri Slaby wrote:
> On 11/18/2007 04:03 PM, Rafael J. Wysocki wrote:
> > Can you also make the new System-map available, please?
> 
> Sure:
> http://www.fi.muni.cz/~xslaby/sklad/System.map1

The last notifier called in http://www.fi.muni.cz/~xslaby/sklad/susp_hang2.png
is apparently cpu_swap_callback() which is not called in
http://www.fi.muni.cz/~xslaby/sklad/susp_hang1.png .

Can you verify that cpu_swap_callback() gets called if the patch is not
applied?
