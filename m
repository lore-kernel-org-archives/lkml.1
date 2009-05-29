Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbZE2MLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbZE2MLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbZE2MLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:11:03 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:45650 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053AbZE2MLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:11:00 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 May 2009 08:11:00 EDT
X-IronPort-AV: E=Sophos;i="4.41,271,1241395200"; 
   d="scan'208";a="5493443"
Message-ID: <4A1FCE8E.2060604@eu.citrix.com>
Date: Fri, 29 May 2009 13:01:18 +0100
From: George Dunlap <george.dunlap@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: "jeremy@goop.org" <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Xen is a feature
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>	<20090528001350.GD26820@elte.hu>	<4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net>
In-Reply-To: <20090528.210559.137121893.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2009 12:01:18.0961 (UTC) FILETIME=[2D0F9E10:01C9E055]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> I don't see Ingo's comments, whether I agree with them or not, as
> an implication of Xen being niche.  Rather I see his comments as
> an opposition to how Xen is implemented.
>   
It's in his definition of "improving Linux".  Jeremy is saying that 
allowing Linux to run as dom0 *is* improving Linux.  The lack of dom0 
support is at this moment making life more difficult for a huge number 
of Linux users who use Xen, including Mozilla, Debian, and Amazon.    
Adding dom0 support would make Linux even more useful to a wide variety 
of people not using Xen at the moment. 

Saying that dom0 support is "not about improving Linux" completely 
ignores the cost people are paying right now, and the benefits people 
could have.  That (if I understand him) what Jeremy meant by saying it 
was treating it as if it was some kind of "niche usage, with barely more 
users than Voyager", and "being a pure drain".
> I don't see any animosity at all in what Ingo has said.
>   
The last few paragraphs of the e-mail weren't about that particular 
argument, but about the sum of the interaction with Ingo over dom0 
support for the last 6 months.  If you read the various threads, it's 
pretty clear that Ingo is resistant to accepting dom0 changes, for 
whatever reason, and has been looking for reasons not to include it. 

If we take him at his word, that the root issue is that he fundamentally 
dislikes the design choice of running Linux-as-hypervisor-component, 
then we have a difference of opinion and we're just going to have to 
agree to disagree.  But there are reasons to include it anyway, 
including benefits to existing Xen users and potential Xen users (who 
have decided not to use KVM for whatever reason), and the idea of 
survival-of-the-fittest: Xen and KVM have made different design choices, 
let's let them both grow and see which one thrives.  If KVM's design is 
unilaterally superior, eventually Xen will die off.  But I suspect that 
there's significant demand in the OSS virtualization ecology for both 
approaches, and the world will be the worse for dom0 support being 
out-of-tree.

In any case, making unreasonable or inconsistent technical objections, 
when the root issue is is actually something else, is a waste of time 
and energy for everyone involved.

 -George
