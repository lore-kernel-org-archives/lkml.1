Return-Path: <linux-kernel-owner+w=401wt.eu-S1767472AbXDFBVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767472AbXDFBVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 21:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767473AbXDFBVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 21:21:00 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49825 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767472AbXDFBU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 21:20:59 -0400
Message-ID: <4615A007.6010701@vmware.com>
Date: Thu, 05 Apr 2007 18:19:03 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com> <200704060154.41574.ak@suse.de> <46158DE1.4050508@vmware.com> <46158F8E.1050807@goop.org> <46158FBE.3090105@vmware.com> <461590EA.10605@goop.org> <4615924E.8020009@vmware.com> <46159555.4020706@goop.org> <4615982A.1070700@vmware.com> <461599C1.50002@goop.org>
In-Reply-To: <461599C1.50002@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> Yes, thought about several solutions, and this seems the best.  But it
>> requires a new paravirt-op.
>>     
>
> Not with the power of multiplexing.  Something like this, perhaps?
>   

Ok, I tried that and I got a nice clean fix.  For 2.6.22.  Backporting 
this to 2.6.21 creates havoc, as a number of cleanup patches as well as 
changes to highmem code get in the way.

Andi, do you really want to deal with the conflicts this will create for 
the paravirt queue for 2.6.22, or would you rather apply the dumb yet 
simple and non-confrontational workaround I have been trying to get 
applied to 2.6.21?

Zach
