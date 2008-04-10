Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYDJOfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYDJOfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbYDJOfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:35:07 -0400
Received: from styx.suse.cz ([82.119.242.94]:51295 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755723AbYDJOfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:35:06 -0400
Date: Thu, 10 Apr 2008 16:35:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Michal Hocko <mhocko@suse.cz>
cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
In-Reply-To: <200804101631.26149.mhocko@suse.cz>
Message-ID: <Pine.LNX.4.64.0804101634180.3896@jikos.suse.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee>
 <200804101555.58643.mhocko@suse.cz> <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz>
 <200804101631.26149.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008, Michal Hocko wrote:

> This is different race with file position IMO. If I understand the 
> report correctly, problem was with sleeping copy_to_user while the f_pos 
> has changed.

Is this really in principle different from obtaining reschedule between 
the two mov instructions?

-- 
Jiri Kosina
SUSE Labs
