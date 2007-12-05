Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbXLEPTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbXLEPTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXLEPS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:18:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbXLEPS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:18:57 -0500
Message-ID: <4756C140.6040601@ce.jp.nec.com>
Date: Wed, 05 Dec 2007 10:18:24 -0500
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Greg KH <gregkh@suse.de>, jbeulich@novell.com
Subject: Re: [PATCH] pci: Omit error message for benign allocation failure
References: <4755AC14.20605@ce.jp.nec.com> <20071204214907.GB9194@us.ibm.com> <4755E174.7040106@ce.jp.nec.com> <20071205014506.GA6034@us.ibm.com>
In-Reply-To: <20071205014506.GA6034@us.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade wrote:
> On Tue, Dec 04, 2007 at 06:23:32PM -0500, Jun'ichi Nomura wrote:
>> Kernel always tries to. But it's best effort basis, IMO.
>> (Maybe your patch is going to fix that?)
> 
> If you are seeing the allocation failures both with and
> without my original patch I doubt that an improved version
> would work.  In my case, the BIOS had allowed sufficient
> resource for the expansion ROMs but was expecting the kernel
> to get it from the non-prefetch instead of prefetch window.

OK. Then it's different from mine.
Thanks for the info.

Regards,
-- 
Jun'ichi Nomura, NEC Corporation of America
