Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbYDGV2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbYDGV2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYDGV2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:28:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbYDGV2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:28:31 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-ohci: conditionally log busReset interrupts
Date: Mon, 7 Apr 2008 17:28:14 -0400
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@redhat.com>
References: <200804041705.16864.jwilson@redhat.com> <tkrat.953b0a6b5de4794b@s5r6.in-berlin.de> <tkrat.f295cee296185297@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f295cee296185297@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071728.14564.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2008 04:33:35 pm Stefan Richter wrote:
> Add a debug option to watch bus reset interrupt events.  Half of this
> patch is taken from Jarod Wilson's first version of the JMicron fix.
> 
> BusReset interrupts are only generated if the respective module
> parameter flag was set before the controller is being initialized.  We
> keep this event masked otherwise to reduce IRQ load in normal operation
> and to avoid potential problems with buggy chips.
> 
> Note, this is unlike the other IRQ events whose logging can be enabled
> any time after chip initialization.  This and the influence on what
> interrupts the chip generates is why I added an extra flag for it.
> 
> Also, reorder the debug parameter flags according to their perceived
> usefulness.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---

Indeed, after discussing, this looks much safer.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>


-- 
Jarod Wilson
jwilson@redhat.com
