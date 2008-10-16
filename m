Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYJPDra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYJPDra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 23:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYJPDrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 23:47:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:35475 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbYJPDrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 23:47:21 -0400
Message-ID: <48F6B8D0.7090307@kernel.org>
Date: Thu, 16 Oct 2008 12:45:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Stack dump from GIT HEAD if CONFIG_ATA_SFF is not set
References: <48F3D8EA.4080708@lwfinger.net> <20081015014128.1bde68cb.akpm@linux-foundation.org>
In-Reply-To: <20081015014128.1bde68cb.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Oct 2008 03:47:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc linux-ide)
> 
>> On Mon, 13 Oct 2008 16:25:30 -0700 Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> I am using kernel 2.6.27-Linus-03151-g4480f15b-dirty. On booting a system built
>> with CONFIG_ATA_SFF not set, the following appears in my dmesg output. The
>> "dirtiness" of the kernel is due to some code included to trace down messages
>> coming from the usb system, and is not involved here. If CONFIG_ATA_SFF=y, the
>> message does not appear. From Google results, it seems that this parameter
>> should be set for most systems, but one should get clean runs without it.

Yeap, working on it.  It seems SFF/BMDMA support needs to be separated
out further.

Thanks for the report.

-- 
tejun
