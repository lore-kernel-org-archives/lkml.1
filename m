Return-Path: <linux-kernel-owner+w=401wt.eu-S932338AbZKMUo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbZKMUo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 15:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932273AbZKMUoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 15:44:23 -0500
Received: from bu3sch.de ([62.75.166.246]:40093 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbZKMUoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 15:44:22 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: 64-bit DMA problems with BCM4312 using b43
Date: Fri, 13 Nov 2009 21:44:21 +0100
User-Agent: KMail/1.9.9
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <4AFD958E.1000303@lwfinger.net> <20091113201112.GA5540@srcf.ucam.org>
In-Reply-To: <20091113201112.GA5540@srcf.ucam.org>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911132144.24110.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009 21:11:12 Matthew Garrett wrote:
> On Fri, Nov 13, 2009 at 11:21:18AM -0600, Larry Finger wrote:
> 
> > I do not know enough about either the ACPI or DMA code to begin debugging in
> > either of those regions. Any suggestions on debugging strategies, or links to
> > similar problems would be appreciated.
> 
> Could the hardware be highly sensitive to DMA latencies? Take a look at 
> the pm_qos code in ipw2100.

This makes perfect sense, yes. The DMA engine has so many quirks, I wouldn't be
surprised if it couldn't handle pm properly.

-- 
Greetings, Michael.
