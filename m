Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbYK0Rji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbYK0Rji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYK0RjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:39:24 -0500
Received: from mail152.ix.emailantidote.com ([89.167.219.152]:3723 "EHLO
	mail1.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753466AbYK0RjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:39:23 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Nov 2008 12:39:23 EST
Message-ID: <492ED945.5010600@draigBrady.com>
Date: Thu, 27 Nov 2008 17:30:45 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mingo@redhat.com, val.henson@gmail.com, matthew@wil.cx,
       util-linux-ng@vger.kernel.org
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default	behaviour
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127160353.GQ2961@nb.net.home>
In-Reply-To: <20081127160353.GQ2961@nb.net.home>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Nov 2008 17:30:47.0474 (UTC) FILETIME=[E26B1120:01C950B5]
x-MXSweep-CtasdSpam: Unknown
x-MXSweep-CtasdVirus: Unknown
x-MXSweep-KeywordsCount: 0
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
X-MXSweep-Threat: Clean
X-MXUniqueID: de8420db-d8ac-47d7-888f-2b04e0e9915e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak wrote:
> On Thu, Nov 27, 2008 at 03:03:41PM +0000, Matthew Garrett wrote:
>> Also add a MS_NORELATIME mount option
> [...]
>> +#define MS_NORELATIME	(1<<24)	/* Disable relatime even if the default */
> 
>  CC: util-linux-ng@vger.kernel.org

That's useful. Without this, to disable relatime you needed to:

echo 0 > /proc/sys/fs/default_relatime
mount -o remount,atime /mnt/point/

