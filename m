Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbYHEEEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbYHEEEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYHEEDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:03:44 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:55043
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723AbYHEEDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:03:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEAA9ul0jLO4pc/2dsb2JhbAAIimalBA
X-IronPort-AV: E=Sophos;i="4.31,307,1215360000"; 
   d="scan'208";a="255280574"
Message-ID: <4897CFE0.2070008@ii.net>
Date: Tue, 05 Aug 2008 11:58:24 +0800
From: Cliffe <cliffe@ii.net>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Casey Schaufler <casey@schaufler-ca.com>, Eric Paris <eparis@redhat.com>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access	scanning
References: <1217883616.27684.19.camel@localhost.localdomain> <4897BFB4.9090309@schaufler-ca.com> <4897C2A7.7020601@ii.net> <20080805034611.GA11399@kroah.com>
In-Reply-To: <20080805034611.GA11399@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Aug 05, 2008 at 11:01:59AM +0800, Cliffe wrote:
>   
>> If we had stackable LSMs then the required functionality could simply be 
>> built into the LSM interface. Then the anti-malware would simply stack 
>> itself with other LSMs.
>>     
>
> Could it really?  How would such an interface work?
>
> Remember, the big issue here isn't the kernel "hooks", but the fact that
> a lot of people are yet to be convinced that something like this needs
> to be within the kernel itself.
>
> Perhaps we should dig up the proposals for the filesystem-notify type
> patches, something like that might be all the majority of the virus
> people need, as they want to just scan things for Windows viruses, not
> Linux ones, and to do so "lazily" might be sufficient.
>   
 From memory Dazuko is a LSM designed for this purpose, although it 
cannot be used on systems running other LSMs due to the lack of stacking 
support. It is used by a bunch of anti-malware programs including ClamAV 
and AVG.
