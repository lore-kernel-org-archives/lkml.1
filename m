Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbZCaO5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbZCaO5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbZCaO4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:56:46 -0400
Received: from fmailhost02.isp.att.net ([204.127.217.102]:55627 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZCaO4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:56:45 -0400
X-Greylist: delayed 141589 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2009 10:56:45 EDT
X-Originating-IP: [69.76.240.125]
Message-ID: <49D22EFC.1020709@lwfinger.net>
Date: Tue, 31 Mar 2009 09:55:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] kaweth: Fix locking to be SMP-safe
References: <49d00512.XAF19LdpY1dlK6+U%Larry.Finger@lwfinger.net> <200903300828.45337.oliver@neukum.org> <49D0EC24.4080206@lwfinger.net> <200903310939.09690.oliver@neukum.org>
In-Reply-To: <200903310939.09690.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> 
> Very good.
> 
>> (X server over the network), the interface stalled with no logged messages.
> 
> Do you get something with sysrq-t ?

No. The rest of the system was still functioning; however, the driver needed to
be unloaded and reloaded before continuing. There were no log entries until the
driver was unloaded.

Larry


