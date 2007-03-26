Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbXCZIxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbXCZIxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXCZIxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:53:31 -0400
Received: from mga05.intel.com ([192.55.52.89]:32362 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750868AbXCZIxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:53:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,328,1170662400"; 
   d="scan'208"; a="219281750:sNHT28391503"
Message-ID: <460789E0.1000600@linux.intel.com>
Date: Mon, 26 Mar 2007 01:52:48 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Shaohua Li <shaohua.li@intel.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New format Intel microcode...
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>	 <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>	 <1174642985.23136.51.camel@aeonflux.holtmann.net>	 <1174640590.1158.219.camel@laptopd505.fenrus.org> <1174898060.5815.11.camel@violet>
In-Reply-To: <1174898060.5815.11.camel@violet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> that is the whole point. The slash was never meant to be used. It was
> designed to take a filename or a pattern that will be later matched by
> userspace. However some developers are now trying to abuse this since
> the simple firmware helper script matches this directly to a filename
> (and directory in this case) on the disk.
> 
> Putting a slash in the request_firmware() call now enforces a
> subdirectory 

I don't see how this follows from the former. Userspace is free to 
translate the kernel string into anything it wants, even a simple 
replacement of / with _. So I don't see how this "enforces" a 
subdirectory. Firmware gets a namespace basically, and a / is a 
logical namespace separator.
