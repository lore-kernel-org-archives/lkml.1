Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbYBEIU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbYBEIU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbYBEIUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:20:48 -0500
Received: from smtp6-g19.free.fr ([212.27.42.36]:47175 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663AbYBEIUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:20:48 -0500
X-Greylist: delayed 53672 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 03:20:47 EST
Message-ID: <47A81C5B.9080000@free.fr>
Date: Tue, 05 Feb 2008 09:20:43 +0100
From: Cedric Le Goater <legoater@free.fr>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, xemul@openvz.org
Subject: Re: [PATCH 2/2] extend clone_flags using parent_tidptr argument
References: <47A74AED.1080806@free.fr>	<20080204202416.GA26422@sergelap.austin.ibm.com> <20080204133810.0077ec0d.akpm@linux-foundation.org>
In-Reply-To: <20080204133810.0077ec0d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 4 Feb 2008 14:24:16 -0600
> "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
>> Quoting Cedric Le Goater (legoater@free.fr):
>>> From: Cedric Le Goater <clg@fr.ibm.com>
>>>
>>> We have at least 2 patchsets requiring each a new clone flag and there it 
>>> is, we've reached the limit, none are left.  
>>> This patch uses the CLONE_DETACHED flag (unused) as a marker to extend the 
>> Are we pretty sure that there is no legacy software out there which has
>> continued to specify CLONE_DETACHED since the kernel ignores it?
> 
> Please see -mm's
> clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
> 
> That patch has been cut back to only recycle CLONE_STOPPED because there
> indeed was software out there which is setting CLONE_DETACHED.
> 
> See http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-11/msg04293.html

bummer, I used the wrong one :/
 
Thanks,

C.
