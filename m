Return-Path: <linux-kernel-owner+w=401wt.eu-S1751104AbZITEQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104AbZITEQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 00:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbZITEQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 00:16:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50986 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZITEQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 00:16:07 -0400
Date: Sun, 20 Sep 2009 05:15:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       rpurdie@rpsys.net, lenb@kernel.org, rui.zhang@intel.com,
       corentincj@iksaif.net
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
Message-ID: <20090920041554.GA9229@srcf.ucam.org>
References: <1247587564-27737-1-git-send-email-mjg@redhat.com> <20090919232424.GA15200@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919232424.GA15200@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 08:24:24PM -0300, Henrique de Moraes Holschuh wrote:

> Should the driver notify of *any* changes, even when the user is hitting the
> "ceiling" or the "floor" and the backlight value didn't really change?

I'd say yes - the user will expect the UI to appear whenever they hit 
the button.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
