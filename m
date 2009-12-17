Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbZLQTwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbZLQTwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbZLQTwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:52:46 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51929 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZLQTwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:52:46 -0500
Date: Thu, 17 Dec 2009 19:52:31 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Lukasz Sokol <el.es.cr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Rfkill buttons : bi-stable, mono-stable, tactile
Message-ID: <20091217195231.GA11747@srcf.ucam.org>
References: <loom.20091217T122606-341@post.gmane.org> <20091217150709.GA6375@srcf.ucam.org> <loom.20091217T161042-883@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20091217T161042-883@post.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please keep me Cc:ed - linux-kernel is high enough traffic that it's 
easy to lose track otherwise)

On Thu, Dec 17, 2009 at 03:17:51PM +0000, Lukasz Sokol wrote:

> I define "not working" in this case by "it switches hardware on/off without the
> software knowing". 
> 
> i.e. the rfkill does not know, and the 'problem' is only noticed when the wifi
> disassociates (but Network Manager tries on to reconnect). On the other hand,
> invoking /sbin/rfkill [un]block wifi blocks/unblocks wifi comfortably.

What does ls -l /sys/class/rfkill look like? What driver are you using 
for your wireless card?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
