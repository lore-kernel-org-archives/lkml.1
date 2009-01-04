Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbZADSgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbZADSgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZADSgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:36:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZADSgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:36:44 -0500
Message-ID: <496101A6.2070405@zytor.com>
Date: Sun, 04 Jan 2009 10:36:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Rob Landley <rob@landley.net>, Sam Ravnborg <sam@ravnborg.org>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
References: <200901020207.30359.rob@landley.net>	<200901020600.47847.rob@landley.net>	<495E6BEE.1000805@zytor.com>	<200901031932.51873.rob@landley.net> <20090104120735.72840fdb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090104120735.72840fdb@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I note that sed and printf and such are all susv3.  I have an explicit test 
>> for 32 bit math in the script that cares, and this worked in Red Hat 9 circa 
>> 2003.
> 
> If you are trying to do arbitary precision maths using standard posix
> tools just use dc. That way the standard is explicit about what you will
> get.

The original patch used bc.  Unfortunately, it ran into bc bugs -- on
some platforms like some of akpm's older test machines it would just hang.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

