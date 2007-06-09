Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbXFIIIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbXFIIIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbXFIIHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:07:16 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:51712
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbXFIIHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:07:12 -0400
Date: Sat, 9 Jun 2007 01:06:09 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sean <seanlkml@sympatico.ca>
cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070609033601.640e83a1.seanlkml@sympatico.ca>
Message-ID: <Pine.LNX.4.64.0706090104210.6675@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
 <20070609014644.9ed4fa29.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706090004290.6675@asgard.lang.hm>
 <20070609033601.640e83a1.seanlkml@sympatico.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Sean wrote:
>> remember that the security hooks in the kernel are not SELinux API's, they
>> are the Loadable Security Model API. What the AA people are asking for is
>> for the LSM API to be modified enough to let their code run (after that
>> (and working in parallel) they will work on getting the rest of their code
>> approved for the kernel, but the LSM hooks are the most critical)
>
> Remember that the SELinux API's essentially belong to everyone under the GPL.
> So its not an excuse for falling into NIH syndrome and putting a bunch of
> new stuff into the kernel that could instead be added as a small
> extension to what already exists.

but the SELinux API's are not the core security API's in Linux, the LSM 
API's are. and AA is useing the LSM API's (extending them where they and 
SELinux don't do what's needed)

David Lang
