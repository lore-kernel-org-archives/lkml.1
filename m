Return-Path: <linux-kernel-owner+w=401wt.eu-S1760755AbYBZOgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbYBZOgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYBZOgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:36:25 -0500
Received: from serenity.mcc.ac.uk ([130.88.200.93]:61732 "EHLO
	serenity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYBZOgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:36:25 -0500
Message-ID: <47C42477.5090900@gentoo.org>
Date: Tue, 26 Feb 2008 14:38:47 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20080212)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       stephen.hemminger@vyatta.com, David Miller <davem@davemloft.net>
Subject: Re: Linux 2.6.24.3 (if_addrlabel.h HEADERS_CHECK failure)
References: <20080226010024.GA26889@suse.de> <20080225195229.11ec1f12.randy.dunlap@oracle.com>
In-Reply-To: <20080225195229.11ec1f12.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>> We (the -stable team) are announcing the release of the 2.6.24.3
>> kernel.
> 
> When HEADERS_CHECK=y:
> 
> make[3]: *** No rule to make target `/local/linsrc/linux-2.6.24.3/include/linux/if_addrlabel.h', needed by `/local/linsrc/linux-2.6.24.3/usr/include/linux/if_addrlabel.h'.  Stop.
> make[2]: *** [linux] Error 2

This appears to have been caused by the patch titled:

	NET: Add if_addrlabel.h to sanitized headers.

The patch only adds the unifdef-y entry for this header file, however 
that header was only added after 2.6.24.

It seems that this patch was submitted to -stable in error. Stephen, can 
you confirm?

Thanks,
Daniel
