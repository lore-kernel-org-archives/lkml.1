Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbYKGBoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbYKGBoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYKGBoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:44:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33181 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYKGBoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:44:02 -0500
Date: Fri, 7 Nov 2008 01:43:42 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Zhao Yakui <yakui.zhao@intel.com>, Len Brown <lenb@kernel.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, Ingo Molnar <mingo@elte.hu>,
       Eduardo Habkost <ehabkost@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
Message-ID: <20081107014342.GA9841@srcf.ucam.org>
References: <fa.UVpnVba3yRAWG3rGZ0sk20JE9hs@ifi.uio.no> <fa.FPBNKx3BSvZHPZ+eXD4Tb+fuRYk@ifi.uio.no> <fa.PvVEuEo+f/t4sLmcGyN2Tsl8zYg@ifi.uio.no> <fa.zzFdOXisTZzBaE1+ueGIYmt+Z5c@ifi.uio.no> <fa.vQ6HVRcPFFr1zpcXFFOjEPtDdNk@ifi.uio.no> <fa.ckUqcrtVKbxAkjNggIdajBTHr9Q@ifi.uio.no> <49139A43.4000203@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49139A43.4000203@shaw.ca>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 07:30:43PM -0600, Robert Hancock wrote:

> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8fd145917fb62368a9b80db59562c20576238f5a
> 
> This patch ignores the RESET_REG_SUP flag and just tries using the reset 
> register anyway if it thinks it's valid. So we may attempt ACPI reset on 
> machines which don't indicate it's supported.

Yeah, that sounds very wrong.

> The patch description mentioned that some machines didn't reboot after 
> S3 suspend without this patch. However, we recently had this patch merged:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a68823ee5285e65b51ceb96f8b13a5b4f99a6888
> 
> Is it possible that the problem fixed there is the true cause of this 
> reboot after S3 problem?

Oh, yeah, could be. Given the From:, I should really have thought of 
that :)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
