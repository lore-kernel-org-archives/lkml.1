Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbXEaILO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbXEaILO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 04:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXEaILD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 04:11:03 -0400
Received: from styx.suse.cz ([82.119.242.94]:51311 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753044AbXEaILB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 04:11:01 -0400
Message-ID: <465E8313.20309@suse.cz>
Date: Thu, 31 May 2007 10:10:59 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.2) Gecko/20061107 SUSE/1.1.1-0.2 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
References: <20070530125954.706423971@suse.cz> <20070530143043.216024061@suse.cz> <20070530170530.GA4197@tuatara.stupidest.org> <200705302348.54259.arnd@arndb.de>
In-Reply-To: <200705302348.54259.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 30 May 2007, Chris Wedgwood wrote:
>> On Wed, May 30, 2007 at 02:59:55PM +0200, Michal Marek wrote:
>>
>>> +typedef struct xfs_fsop_geom_v132 {
>> wouldn't xfs_fsop_geom_v1_32
...
>> and xfs_fsop_geom_v1_32_t
>>                     ^
>>
>> read better there?
> 
> Actually, the current convention would be struct compat_xfs_fsop_geom_v1
> and compat_xfs_fsop_geom_v1_t.

I see. I'll change it to struct compat_xfs_*.

Michal
