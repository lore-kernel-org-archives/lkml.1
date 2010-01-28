Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806Ab0A1Mb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0A1Mb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231Ab0A1Mb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:31:56 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:57500 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0A1Mbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:31:55 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B618412.30704@cam.ac.uk>
Date: Thu, 28 Jan 2010 12:33:22 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jean Delvare <khali@linux-fr.org>, Zhang Rui <rui.zhang@intel.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next:als tree build failure
References: <20100128182334.7226bdf6.sfr@canb.auug.org.au>	<20100128084107.682db589@hyperion.delvare>	<4B617C29.6010300@cam.ac.uk> <20100128231750.1dd29044.sfr@canb.auug.org.au>
In-Reply-To: <20100128231750.1dd29044.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/10 12:17, Stephen Rothwell wrote:
> Hi Jonathan, Jean,
> 
> On Thu, 28 Jan 2010 11:59:37 +0000 Jonathan Cameron <jic23@cam.ac.uk> wrote:
>>
>> It does make sense to keep these two steps separate.  Ah well, I guess any
>> work around would be a pretty terrible cludge.  I'll roll these two patches
>> back together and otherwise we will end up with something even less coherent.
> 
> OK, thanks guys.
> 
Everything should now be fixed in the als tree.  New version of the move commit
cleans out the i2c/chips directory and changes the i2c/Makefile and i2c/Kconfig
appropriately.  Only remaining related elements are the debug Kconfig option for
i2c/chips but that can definitely go through the i2c tree rather than als (if there
are no other users) and shouldn't break any builds.

Thanks,

Jonathan

