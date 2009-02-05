Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbZBETwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbZBETwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbZBETw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:52:28 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:20240 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252AbZBETw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:52:27 -0500
Message-ID: <498B437C.5030101@oracle.com>
Date: Thu, 05 Feb 2009 11:52:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, len.brown@intel.com
Subject: Re: PATCH:  Allow over-ride of smp_found_cfg with kernel cmd-line
 option.
References: <498B421D.9090609@candelatech.com>
In-Reply-To: <498B421D.9090609@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.498B4374.010A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear wrote:
> Allow user to keep smp_found_cfg set to 1 even if MADT
> cannot be parsed.  This works around funky BIOS on FWA-7304
> (VIA CN700 chipset) system, and possibly other systems as well.
> Without this override, performance drops by around 15% on
> network throughput tests on this system.
> 
> This is based on 2.6.29-rc3
> 
> Signed-Off-By:  Ben Greear <greearb@candelatech.com>


Both patches (smp and tsc) need entries in Documentation/kernel-parameters.txt
(if they are accepted/merged).

And thunderbird can be coerced into sending patches inline instead of
using attachments... please.  Documentation/email-clients.txt might help you.

Thanks,
-- 
~Randy
