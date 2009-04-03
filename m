Return-Path: <linux-kernel-owner+w=401wt.eu-S935582AbZDCRnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935582AbZDCRnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765319AbZDCRnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:43:21 -0400
Received: from fe1.instantservice.com ([66.150.11.104]:21191 "EHLO
	mx1.instantservice.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760475AbZDCRnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:43:20 -0400
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Apr 2009 13:43:19 EDT
Date: Fri, 3 Apr 2009 10:33:27 -0700 (PDT)
From: Sun Microsystems Sales Support <sun-sales-support@sun.com>
Reply-To: Sun Microsystems Sales Support <sun-sales-support@sun.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: casey@schaufler-ca.com, sds@tycho.nsa.gov, matthew.dodd@sparta.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
Message-ID: <24068406.2060451238780007952.JavaMail.root@ms1b.instantservice.com>
Subject: RE: Re: [PATCH 08/14] NFSv4: Add label recommended attribute and
 NFSv4 flags (#6127-130006249-0129)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




-----Original Message-----
From: David P. Quigley (dpquigl@tycho.nsa.gov)
Sent: Apr 3, 2009 8:32:49 AM
Subject: Re: [PATCH 08/14] NFSv4: Add label recommended attribute and NFSv4 flags

On Fri, 2009-04-03 at 22:43 +1100, James Morris wrote:
> On Fri, 3 Apr 2009, David P. Quigley wrote:
> 
> > We tried to change this to be dynamically allocated based on what was
> > coming off of the wire but we ran into a problem that it required us to
> > do allocations where they really shouldn't be done in the rpc/nfsv4
> > code. Trond suggested to make this static and that if someone really
> > needed more than a page for their label that something was horrifically
> > wrong. I'm tempted to agree with him on this but there are people trying
> > to send contexts with an MLS component with every other compartment set
> > which tend to be really large. 
> 
> Well, future labels might include cryptographic information, for example.
This report relates to a message you sent with the following header fields:

Message - ID: 134806025
From: dpquigl@tycho.nsa.gov
Subject: Re: [PATCH 08/14] NFSv4: Add label recommended attribute and NFSv4 flags


Your message cannot be delivered to the following recipients:

Recipient Address:  Lawrence.Bowers@sun.com 
Reason:  This address is no longer available

> 

<removing people from the CC who probably don't care about this>

Could you expand on why this might be needed or what applications would
use this? It's unclear to me what sort of crypto information would be in
a context. I know the ecryptfs guys were trying to make crypto decisions
based on SELinux context in some cases but I never heard of wanting to
put that kind of information into the context.

Dave


--
This message was distributed to subscribers of the selinux mailing list.
If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
the words "unsubscribe selinux" without quotes as the message.


