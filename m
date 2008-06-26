Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbYFZSUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbYFZSUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbYFZST7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:19:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56167 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623AbYFZST6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:19:58 -0400
Date: Thu, 26 Jun 2008 19:19:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Phillip Killewald <killewald.1@osu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Toshiba laptop bluetooth power control patch
Message-ID: <20080626181951.GA17943@srcf.ucam.org>
References: <486382D7.6010105@osu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486382D7.6010105@osu.edu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 01:51:51PM +0200, Phillip Killewald wrote:
> 2.6.21.  The patch creates an entry /proc/acpi/toshiba/bluetooth, which
> you can use to power-up and attach the bluetooth device with the
> commands cat 'power: 1' >> /proc/acpi/toshiba/bluetooth and 'attach: 1'
> >> /proc/acpi/toshiba/bluetooth.

Please use rfkill instead. Adding new custom files to /proc ends up 
making it harder to convert them all over later :)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
