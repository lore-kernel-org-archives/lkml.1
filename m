Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZLROPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZLROPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZLROPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:15:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47990 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbZLROPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:15:49 -0500
Date: Fri, 18 Dec 2009 14:15:43 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Lukasz Sokol <el.es.cr@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Rfkill buttons : bi-stable, mono-stable, tactile
Message-ID: <20091218141543.GA24825@srcf.ucam.org>
References: <loom.20091217T122606-341@post.gmane.org> <20091217150709.GA6375@srcf.ucam.org> <loom.20091217T161042-883@post.gmane.org> <20091217195231.GA11747@srcf.ucam.org> <4B2B42B6.1010501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2B42B6.1010501@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 08:52:06AM +0000, Lukasz Sokol wrote:

> lrwxrwxrwx 1 root root 0 2009-12-17 20:30 rfkill0 -> ../../devices/pci0000:00/0000:00:1c.2/0000:03:00.0/ieee80211/phy0/rfkill0

Ok. You have no platform rfkill interface. ath5k needs to notice that 
it's been killed and update its rfkill state accordingly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
