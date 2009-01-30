Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbZA3VDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbZA3VDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZA3VDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:03:04 -0500
Received: from relay1.allsecurenet.com ([66.111.57.92]:59345 "EHLO
	relay1.allsecurenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZA3VDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:03:03 -0500
X-Greylist: delayed 2517 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jan 2009 16:03:03 EST
Message-ID: <49836114.1090209@buttersideup.com>
Date: Fri, 30 Jan 2009 20:20:36 +0000
From: Tim Small <tim@buttersideup.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Doug Thompson <norsk5@yahoo.com>, ncunningham-lkml@crca.org.au,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Chris Friesen <cfriesen@nortel.com>, Pavel Machek <pavel@suse.cz>,
       bluesmoke-devel@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: marching through all physical memory in software
References: <715599.77204.qm@web50111.mail.re2.yahoo.com> <m1wscc7fop.fsf@fess.ebiederm.org>
In-Reply-To: <m1wscc7fop.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> A background software scrubber simply has the job of rewritting memory
> to it's current content so that the data and the ecc check bits are
> guaranteed to be in sync

Don't you just need to READ memory?  The memory controller hardware 
takes care of the rest in the vast majority of cases.

You only need to rewrite RAM if a correctable error occurs, and the 
chipset doesn't support automatic write-back of the corrected value (a 
different problem altogether...).  The actual memory bits themselves are 
refreshed by the hardware quite frequently (max of every 64ms for DDR2, 
I believe)...

Cheers,

Tim.
