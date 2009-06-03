Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbZFCRbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbZFCRbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbZFCRba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:31:30 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:62725 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbZFCRba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:31:30 -0400
Message-ID: <4A26B361.5000600@nortel.com>
Date: Wed, 03 Jun 2009 11:31:13 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
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
Subject: Re: Merge Xen (the hypervisor) into Linux
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <20090602224051.GB32428@goodmis.org> <20090602232843.GA6577@elte.hu>
In-Reply-To: <20090602232843.GA6577@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2009 17:31:19.0845 (UTC) FILETIME=[1B5F7D50:01C9E471]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> A lot of Xen legacies could be dropped: the crazy ring1 hack on 
> 32-bit, the various wide interfaces to make pure-software 
> virtualization limp along. All major CPUs shipped with hardware 
> virtualization support in the past 2-3 years, so the availability of 
> VMX and SVM can be taken for granted for such a project.

That's a pretty bold statement.  I have five x86 machines in my house
currently being used, and none of them support VMX/SVM.

At least some Lenovo laptops disable VMX in the BIOS with no way to
enable it.  Some of the Core2Duo chips don't support VMX at all.

I think Xen without paravirtualization would be a serious degradation of
usefulness.

Chris
