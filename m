Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbXFIHhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbXFIHhI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXFIHgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:36:55 -0400
Received: from bay0-omc3-s22.bay0.hotmail.com ([65.54.246.222]:38983 "EHLO
	bay0-omc3-s22.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbXFIHgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:36:54 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Sat, 9 Jun 2007 03:36:01 -0400
From: Sean <seanlkml@sympatico.ca>
To: david@lang.hm
Cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
Message-Id: <20070609033601.640e83a1.seanlkml@sympatico.ca>
In-Reply-To: <Pine.LNX.4.64.0706090004290.6675@asgard.lang.hm>
References: <20070514110607.549397248@suse.de>
	<200706042303.28785.agruen@suse.de>
	<1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
	<200706090003.57722.agruen@suse.de>
	<20070609001703.GA17644@kroah.com>
	<Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
	<20070609014644.9ed4fa29.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706090004290.6675@asgard.lang.hm>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2007 07:37:18.0203 (UTC) FILETIME=[01CFC4B0:01C7AA69]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 00:13:22 -0700 (PDT)
david@lang.hm wrote:

> did you read my explination of the analogy?

It was a rather poor analogy i'm afraid.  But the point i make still stands.
So far you've failed to show any reason SELinux can't be reasonably extended
to handle all the features you care about.

> what SELinux cannot do is figure out what label to assign a new file.

That would be the job of your AA extension.

> but the bigger problem in changing SELinux to behave like AA is that the 
> SELinux people disagree with the concept of AA. they don't believe that 
> it's secure, so why would they add useless bloat that would only 
> complicate their code and make systems less secure? I don't happen to 
> agree with their opinion of AA obviously, but they have the right to their 
> opinion, and it is their code. why should they be asked to implement and 
> support something they disagree with so fundamentally?

So now you're claiming the real reason to let AA into the kernel is
politics? 

Just show that the feature can be easily added to SELinux and made as an
option for the end user to choose and it should go a long way to silencing
the opponents.

> 
> remember that the security hooks in the kernel are not SELinux API's, they 
> are the Loadable Security Model API. What the AA people are asking for is 
> for the LSM API to be modified enough to let their code run (after that 
> (and working in parallel) they will work on getting the rest of their code 
> approved for the kernel, but the LSM hooks are the most critical)

Remember that the SELinux API's essentially belong to everyone under the GPL.
So its not an excuse for falling into NIH syndrome and putting a bunch of
new stuff into the kernel that could instead be added as a small
extension to what already exists.

Sean

