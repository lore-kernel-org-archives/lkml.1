Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYHSQee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYHSQee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYHSQe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:34:26 -0400
Received: from brmea-mail-4.Sun.COM ([192.18.98.36]:40114 "EHLO
	brmea-mail-4.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYHSQeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:34:25 -0400
Date: Tue, 19 Aug 2008 08:34:07 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro to a
 linux interface for on access scanning
In-reply-to: <alpine.DEB.1.10.0808190845000.12859@asgard.lang.hm>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>, Peter Dolding <oiaohm@gmail.com>,
       Pavel Machek <pavel@suse.cz>, rmeijer@xs4all.nl
Reply-to: davecb@sun.com
Message-id: <48AABDBF.7090706@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080819083240.E5E532FE82F@pmx1.sophos.com>
 <alpine.DEB.1.10.0808190845000.12859@asgard.lang.hm>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> if you want to be sure there are no race conditions at all in this there 
> would be a need for an 'atomic' (as relates to userspace) way to set an 
> xattr only if another one was set.

Hmmn, such code would rather resemble the O_CREAT|O_EXCL handling in open(2).

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
cell: (647) 833-9377, bridge: (877) 385-4099 code: 506 9191#
