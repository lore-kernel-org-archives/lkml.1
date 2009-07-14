Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZGNBxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZGNBxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 21:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbZGNBxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 21:53:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60004 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbZGNBxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 21:53:30 -0400
Date: Tue, 14 Jul 2009 02:53:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: ykzhao <yakui.zhao@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
       "lenb@kernel.org" <lenb@kernel.org>, "Zhang, Rui" <rui.zhang@intel.com>,
       "corentincj@iksaif.net" <corentincj@iksaif.net>
Subject: Re: [PATCH 1/3] backlight: Allow drivers to update the core, and
	generate events on changes
Message-ID: <20090714015326.GA9044@srcf.ucam.org>
References: <1247517685-7719-1-git-send-email-mjg@redhat.com> <1247533128.3704.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247533128.3704.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 08:58:48AM +0800, ykzhao wrote:

> It will be better to send the event to user space only when the
> brightness is updated successfully.

That guarantees that we have to read back the brightness, which may be 
expensive on some hardware.

> It seems that the acpi video driver will send the ACPI event to user
> space when updating the brightness. 
> Is it necessary to send the udev-event again?

Yes. There's no reason to special-case the ACPI driver.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
