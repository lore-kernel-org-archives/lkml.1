Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbYACNI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbYACNI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYACNIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:08:47 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:34828 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYACNIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:08:45 -0500
Date: Thu, 3 Jan 2008 13:09:29 +0000
From: Andy Whitcroft <andyw@uk.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Make checkpatch.pl's quiet option not print the summary on no errors
Message-ID: <20080103130929.GF10861@shadowen.org>
References: <477C3252.1080001@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477C3252.1080001@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 01:54:42AM +0100, Arjan van de Ven wrote:
> Subject: Make checkpatch.pl's quiet option not print the summary on no 
> errors
> From: Arjan van de Ven <arjan@linux.intel.com>
> CC: apw@uk.ibm.com
> 
> Right now, in quiet mode, checkpatch.pl still prints a summary line even
> if the patch is 100% clean. IMO, "quiet mode" should mean "no output if 
> clean",
> the patch below makes that so. (This also makes the quilt integration
> on my system work nicer :)
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

I think that sounds reasonable.  Should people want the summary
regardless it makes more sense to provice an option for that, perhaps a
doubling of the --summary flag.

Will be in 0.13.

-apw
