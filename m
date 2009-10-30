Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZJ3FLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZJ3FLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 01:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZJ3FLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 01:11:08 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:55384 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754700AbZJ3FLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 01:11:07 -0400
Message-ID: <4AEA755A.20003@snapgear.com>
Date: Fri, 30 Oct 2009 15:10:50 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v4 7/7] m68knommu: Split the .init section into INIT_TEXT_SECTION
 and INIT_DATA_SECTION.
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu> <1255886635-17371-7-git-send-email-tabbott@ksplice.com> <4AEA3DC9.7080205@snapgear.com> <alpine.DEB.1.10.0910292116511.24830@dr-wily.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0910292116511.24830@dr-wily.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott wrote:
> On Fri, 30 Oct 2009, Greg Ungerer wrote:
>> The whole series applied and ran fine for me!
>> (Of course excepting the define name clash in 1/7)
> 
> Thanks for your patience debugging this patch series!
> 
>> Do you want me to push these into m68knommu.git?
> 
> Yes, that'd be great.  Do you expect these to end up in 2.6.32?

No, I wouldn't want to push them this late in the 2.6.32 cycle.
Definitely for 2.6.33 (I anticipate pushing them in the 2.6.33
merge window).


>  I have an 
> API change to INIT_DATA_SECTION that I want to put in 2.6.32 to fix a tiny 
> regression on blackfin, and I'd like to know which change is likely to get 
> merged first (since the API change will likely conflict).

I have put them in the "for-linus" branch of:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
