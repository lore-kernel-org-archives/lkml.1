Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYFXGSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYFXGSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 02:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYFXGSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 02:18:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:51269 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbYFXGSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 02:18:34 -0400
Message-ID: <486091A8.9010102@kernel.org>
Date: Tue, 24 Jun 2008 15:18:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pci: VT3336 can't do MSI either
References: <48608792.7090909@kernel.org> <20080623225302.ab7b35de.akpm@linux-foundation.org>
In-Reply-To: <20080623225302.ab7b35de.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Tue, 24 Jun 2008 06:18:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 24 Jun 2008 14:35:14 +0900 Tejun Heo <tj@kernel.org> wrote:
> 
>> It seems VT3336 can't do msi either as with its bro 3351.  Disable it.
>> Reported in the following SUSE bug.
>>
>>   https://bugzilla.novell.com/show_bug.cgi?id=300001
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> (argh.  Is that permanent(ish)?)

I believe the link will stay for some time to come and the information
there isn't critical anyway.  The only controller which can do MSI on
the board is ahci and the situation is just the same as the other via
chip.  I just didn't want to lose the mail address of the reporter and
wasn't too sure whether he/she would want to be cc'd on public mailing list.

If you were talking about the email address, I've had quite a few
problems with my gmail account lately including being kicked out of all
the mailing lists regularly, so yeah I think I'm gonna use @kernel.org
from now on.

Thanks.

-- 
tejun
