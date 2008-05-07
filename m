Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYEGL20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYEGL20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYEGL2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:28:15 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:55630 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYEGL2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:28:13 -0400
Message-ID: <48219287.1030904@keyaccess.nl>
Date: Wed, 07 May 2008 13:29:11 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Pete Clements <clem@clem.clem-digital.net>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: Lost Sound from 2.6.24 to 2.6.25 -- CS4236 ISA
References: <200805070257.m472v9vu004722@clem.clem-digital.net>
In-Reply-To: <200805070257.m472v9vu004722@clem.clem-digital.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-05-08 04:57, Pete Clements wrote:

> Had a cold reboot today, now 2.6.25 is working just like 2.6.24. Have rebooted
> in and out of 25 multi time and all is fine. Nothing changed to my knowledge so
> I can't explain, must have had something screwed up. 
> 
> Problem does exist post 2.6.25, except just silence. Did manage to get the
> cyclic noise back after removing pnp, failing a module load, and adding pnp
> back with warm reboots. 
> 
> System will not configure PNPACPI.

Okay, thanks. Reproduced the silence (with a different ISAPnP soundcard, the 
AD1815). Will debug later today.

That "cyclic noise" thing is odd but I expect that's simply a side effect of 
the chip not initializing itself so that some connections are kept floating.

Rene.
