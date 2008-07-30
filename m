Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbYG3MMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbYG3MMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYG3MMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:12:40 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:54482 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYG3MMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:12:39 -0400
Message-ID: <48905B4B.9090203@keyaccess.nl>
Date: Wed, 30 Jul 2008 14:15:07 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Pete Clements <clem@clem.clem-digital.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc1 oops on boot -- cs423x? (Corrected subject)
References: <200807292052.m6TKq1J3005288@clem.clem-digital.net> <488FAFA6.4070300@keyaccess.nl> <200807292159.43226.bjorn.helgaas@hp.com>
In-Reply-To: <200807292159.43226.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-07-08 05:59, Bjorn Helgaas wrote:

> PNP: fix formatting of dbg_pnp_show_resources() output
> 
> From: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> Each resource should be printed on its own line, so start snprintf'ing
> at the beginning of the buffer every time through the loop.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Good WARN_ON() that...

I was looking at why I hadn't seen this here even with the same hardware 
when I _did_ see it here. Most definitely did not back when I was paying 
attention -- although there seems to be little opportunity for that.

Just for my own education; did something recent happen to bring this on 
or must this have been present always? Serious buglet it seems.

Rene
