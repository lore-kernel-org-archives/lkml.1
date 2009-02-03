Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZBCOcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZBCOcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZBCOcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:32:36 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:46867 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbZBCOcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:32:35 -0500
Message-ID: <4988555B.8010408@nortel.com>
Date: Tue, 03 Feb 2009 08:31:55 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Doug Thompson <norsk5@yahoo.com>, ncunningham-lkml@crca.org.au,
       Pavel Machek <pavel@suse.cz>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: marching through all physical memory in software
References: <715599.77204.qm@web50111.mail.re2.yahoo.com> <m1wscc7fop.fsf@fess.ebiederm.org>            <49873B99.3070405@nortel.com> <37985.1233614746@turing-police.cc.vt.edu>
In-Reply-To: <37985.1233614746@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Feb 2009 14:32:01.0359 (UTC) FILETIME=[2D3ECDF0:01C9860C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 02 Feb 2009 12:29:45 CST, Chris Friesen said:
> 
>>The next question is who handles the conversion of the various different 
>>arch-specific BIOS mappings to a standard format that we can feed to the 
>>background "scrub" code.  Is this something that belongs in the edac 
>>memory controller code, or would it live in /arch/foo somewhere?
> 
> 
> If it's intended to be something basically stand-alone that doesn't require
> an actual EDAC chipset, it should probably live elsewhere.  Otherwise, you get
> into the case of people who don't enable it because they "know" their hardware
> doesn't have an EDAC ability, even if they *could* benefit from the function.
> 
> On the other hand, if it's an EDAC-only thing, maybe under drivers/edac/$ARCH?

I don't see anything in the name of EDAC that implies hardware only...a 
software memory scrub could be considered "error detection and 
correction".  Might have to update the config help text though.

Chris

