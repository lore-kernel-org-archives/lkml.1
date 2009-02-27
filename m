Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZB0Mgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZB0Mgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 07:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZB0Mg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 07:36:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbZB0Mg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 07:36:27 -0500
Message-ID: <49A7DE0D.5090205@zytor.com>
Date: Fri, 27 Feb 2009 04:35:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Anders Kaseorg <andersk@MIT.EDU>
CC: Tim Abbott <tabbott@MIT.EDU>, linux-kernel@vger.kernel.org,
       Jeff Arnold <jbarnold@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] modpost: Check the section flags, not name, to catch
 missing "ax"/"aw"
References: <1235521315-3424-1-git-send-email-tabbott@mit.edu> <1235521315-3424-2-git-send-email-tabbott@mit.edu> <1235521315-3424-3-git-send-email-tabbott@mit.edu> <49A49D2B.8050701@zytor.com> <alpine.DEB.2.00.0902262057080.9996@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.2.00.0902262057080.9996@vinegar-pot.mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Kaseorg wrote:
> On Tue, 24 Feb 2009, H. Peter Anvin wrote:
>> This is a pretty critical set of warnings, that often represent real 
>> bugs.  I don't think it's acceptable to lose them.  However, you already 
>> have (prior in the sequence) changed those section names to not conflict 
>> with the automatically generated ones, so it seems to me that this 
>> should be fixable without too much pain.
> 
> Actually, the problem arises from a conflict between two classes of 
> automatically generated section names, one from ld, and one from gcc.  
> Instead of basing the warning on section names (the existing heuristic 
> also fails to warn on some cases where it should, as it turns out), what 
> do you think about this patch?  I've tested that it still triggers the 
> warning when an "ax" or "aw" is incorrectly removed, and it should handle 
> even more cases than before.
> 

Seems reasonable to me.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

