Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYDBPWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYDBPWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbYDBPVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:21:53 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:52545 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbYDBPVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:21:53 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 2.6.25-rc7/rc8 USB dead on resume
Date: Wed, 2 Apr 2008 17:21:49 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org
References: <47EBBD57.30902@rtr.ca> <47F39A80.9090201@rtr.ca> <47F3A0B1.1030205@rtr.ca>
In-Reply-To: <47F3A0B1.1030205@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021721.50168.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 2. April 2008 17:05:21 schrieb Mark Lord:
> Mark Lord wrote:

> No change in -rc8.  I've uploaded new syslog (with alt-sysrq-T) and .config
> as attachements to the bugzilla entry:
> 
>     http://bugzilla.kernel.org/show_bug.cgi?id=10345
> 
> 

Same analysis. ehci_endpoint_disable() is spinning and ksuspend_usb
is waiting for it.

	Regards
		Oliver

PS: Sorry for not looking at the full bugzilla entry

