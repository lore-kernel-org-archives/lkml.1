Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbXJKXVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbXJKXVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 19:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXJKXVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 19:21:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48211 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbXJKXVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 19:21:11 -0400
Message-ID: <470EAE84.3010704@redhat.com>
Date: Thu, 11 Oct 2007 19:15:16 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Stefan Scheler <stefan@scheler.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression from 2.6.21 to 2.6.22 and above
References: <fekuk7$kpl$1@sea.gmane.org>
In-Reply-To: <fekuk7$kpl$1@sea.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2007 06:41 AM, Stefan Scheler wrote:
> Hello,
> 
> my Kobil KAAN Professional (USB variant) smartcard reader stopped
> working when upgrading from 2.6.21 to 2.6.22 (and 2.6.23). Not working
> means that the latest libct.so supplied from Kobil is segfaulting when
> trying to access the device. But as far as I can see the kobil_sct
> driver itself didn't change from 2.6.21 to 2.6.22. Any ideas what is
> going on here?
> 
> Thanks in advance. I will provide additional information if needed.
> 

Try turning off USB autosuspend by adding the kernel option
"usbcore.autosuspend=-1". Or if your USB is modular, add "autosuspend=-1"
to the module parameters.

