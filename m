Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbZBESA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbZBESA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbZBESAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:00:38 -0500
Received: from gw.goop.org ([64.81.55.164]:39145 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151AbZBESAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:00:37 -0500
Message-ID: <498B2943.8000602@goop.org>
Date: Thu, 05 Feb 2009 10:00:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: __supported_pte_mask breaks PROT_NONE pages
References: <498A5002.9080408@goop.org> <20090205142912.GE28443@elte.hu> <498B20A7.4060405@goop.org> <20090205173050.GB24599@elte.hu>
In-Reply-To: <20090205173050.GB24599@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>> btw., did you actually see a boot crash due to this, on a pre-PGE system?
>>>   
>>>       
>> No, under Xen, since it also disables PGE.
>>     
>
> but it was a boot crash, right? Such info is useful in the first line of a 
> commit message:
>
>   Impact: fix non-PGE boot crash
>
> (that also makes it less likely that the commit is under-prioritized.)

It's not immediate; in early usermode.  It only happens when using a 
populated PROTNONE page, which is actually pretty rare, it seems - 
perhaps made more common by the new mlock code.  But, yes, it stopped my 
machine from booting.

    J
