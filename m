Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0CBXji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:39:38 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39660 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab0CBXjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:39:32 -0500
Date: Tue, 2 Mar 2010 23:39:29 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@novell.com>,
       Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 58/62] msi-laptop: Support some MSI 3G netbook that is
	need load SCM
Message-ID: <20100302233929.GB13739@srcf.ucam.org>
References: <20100302230933.GA32287@kroah.com> <1267572541-410-58-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267572541-410-58-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 03:28:57PM -0800, Greg Kroah-Hartman wrote:
> From: Lee, Chun-Yi <jlee@novell.com>
> 
> Some MSI 3G netbook only have one fn key to control Wlan/Bluetooth/3G,
> those netbook will load the SCM (windows app) to disable the original
> Wlan/Bluetooth control by BIOS when user press fn key, then control
> Wlan/Bluetooth/3G by SCM (software control by OS). Without SCM, user
> cann't on/off 3G module on those 3G netbook.
> On Linux, msi-laptop driver will do the same thing to disable the
> original BIOS control, then might need use HAL or other userland
> application to do the software control that simulate with SCM.
> e.g. MSI N034 netbook

How does the function key event get reported to userland? This should 
generate KEY_RFKILL and then just go through rfkill-input.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
