Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbZBDQEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbZBDQEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZBDQEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:04:12 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:34150 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbZBDQEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:04:11 -0500
Message-ID: <4989BC67.3090708@nortel.com>
Date: Wed, 04 Feb 2009 10:03:51 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Valdis.Kletnieks@vt.edu, "Eric W. Biederman" <ebiederm@xmission.com>,
       Doug Thompson <norsk5@yahoo.com>, ncunningham-lkml@crca.org.au,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, bluesmoke-devel@lists.sourceforge.net
Subject: Re: marching through all physical memory in software
References: <715599.77204.qm@web50111.mail.re2.yahoo.com> <m1wscc7fop.fsf@fess.ebiederm.org> <49873B99.3070405@nortel.com> <37985.1233614746@turing-police.cc.vt.edu> <4988555B.8010408@nortel.com> <20090203222501.GC2857@elf.ucw.cz>
In-Reply-To: <20090203222501.GC2857@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Feb 2009 16:03:56.0798 (UTC) FILETIME=[2F1DC1E0:01C986E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

>>I don't see anything in the name of EDAC that implies hardware only...a  
>>software memory scrub could be considered "error detection and  
>>correction".  Might have to update the config help text though.
> 
> 
> Software memory scrub would no longer be a "driver" :-). So it should
> go into kernel/scrub or mm/scrub or maybe mm/edac or something.

True enough.  In that case, something under "mm" makes more sense to me 
than something under "kernel".

Chris
