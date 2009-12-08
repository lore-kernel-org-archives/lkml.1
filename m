Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZLHPro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZLHPro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZLHPrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:47:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39028 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbZLHPrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:47:41 -0500
Date: Tue, 8 Dec 2009 15:47:38 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lenb@kernel.org
Subject: Re: [PATCH] Toshiba Bluetooth enabler (rfkill)
Message-ID: <20091208154738.GC26435@srcf.ucam.org>
References: <4B192D08.9080608@gmail.com> <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com> <20091208125530.GA23520@srcf.ucam.org> <4B1E7481.6020902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E7481.6020902@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 04:45:05PM +0100, Jes Sorensen wrote:
> On 12/08/09 13:55, Matthew Garrett wrote:
>> The problem with that is that there's no event to indicate that the
>> switch has been turned back on, so there's no way to update the rfkill
>> core appropriately. Giving userspace potentially stale information
>> doesn't seem helpful.
>
> I believe I can call into BTST and determine whether the switch is set
> to on or not. It's quite easy to add this to the resume handler and only
> call if it's set to on.

Right, but in normal use it's an issue. Unless we get notifications for 
both types of state change, we can't add an rfkill device.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
