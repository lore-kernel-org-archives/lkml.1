Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbXFOXBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbXFOXBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758973AbXFOXBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:01:16 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:45882 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758859AbXFOXBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:01:15 -0400
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 19:01:15 EDT
Date: Fri, 15 Jun 2007 16:01:14 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
cc: Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
In-Reply-To: <4673194D.4090500@intel.com>
Message-ID: <Pine.LNX.4.64.0706151558180.27993@blackbox.fnordora.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673194D.4090500@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Kok, Auke wrote:

> Jack Stone wrote:
>> I hope I got the CC list right. Apologies to anyone in didn't include
>> and anyone I shouldn't have included.
>> 
>> The basic idea is to include an idea from VMS that seems to be quite
>> useful: version numbers for files.
>
> <snip>
>
> have you looked into ext3cow? it allows you to take snapshots of the entire 
> ext3 fs at a single point, and rollback / extract snapshots at any time 
> later. This may be sufficient for you and the implementation seems to be 
> rather stable already.

As long as there is only one person using the file system.  Rolling back 
the entire filesystem may work well for you, but screw up something else 
someone else is doing.

And what kind of rights do you have to assign to the user to do that level 
of snapshot and rollback?  You have to assume that there are more than one 
user and that they have less than root privileges.

-- 
"ANSI C says access to the padding fields of a struct is undefined.
ANSI C also says that struct assignment is a memcpy. Therefore struct
assignment in ANSI C is a violation of ANSI C..."
                                   - Alan Cox
