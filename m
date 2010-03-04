Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0CDRJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:09:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58142 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab0CDRJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:09:07 -0500
Date: Thu, 4 Mar 2010 17:09:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Joey Lee <jlee@novell.com>
Cc: mzxreary@0pointer.de, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 58/62] msi-laptop: Support some MSI 3G netbook that is
	need load SCM
Message-ID: <20100304170902.GA21531@srcf.ucam.org>
References: <4B90839902000023000142EB@novprvlin0050.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B90839902000023000142EB@novprvlin0050.provo.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 10:07:53AM -0700, Joey Lee wrote:
> Thank's for your review and suggestion.
> Per discuss for msi-laptop patchset, I will submit a bit patch for the
> following change:
> 	- remove threeg sysfs interface.
> 	- add KEY_RFKILL keymapping to msi-laptop.

If the key event comes through the keyboard controller, there's no need 
to add the mapping to msi-laptop. Doing it through udev or hal is fine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
