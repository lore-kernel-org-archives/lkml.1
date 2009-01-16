Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbZAPL4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbZAPL4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758722AbZAPL4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:56:32 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:50144 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957AbZAPL4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:56:31 -0500
Message-Id: <49708423.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 16 Jan 2009 11:57:07 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: simplify HIGHMEM-related Kconfig entries
References: <496DE927.76E4.0078.0@novell.com> <496E3F7D.2060908@zytor.com>
 <496F0796.76E4.0078.0@novell.com> <20090115085728.GA28607@elte.hu>
 <496F6DFC.90006@zytor.com>
In-Reply-To: <496F6DFC.90006@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 15.01.09 18:10 >>>
>Ingo Molnar wrote:
>>>>
>>>> 	No highmem	- No highmem, no PAE
>>>> 	HIGHMEM4G	- Highmem, no PAE
>>>> 	HIGHMEM64G	- Highmem, PAE
>>>>
>>>> So X86_PAE and HIGHMEM4G is a bit of a contradiction.  I haven't looked 
>>>> at the logic in detail, or remember offhand if there have been any 
>>>> weakening of the definitions above; e.g. someone could have implemented 
>>>> a way to do PAE without highmem, to get access to the NX bits.
>>> Exactly - .23 made PAE an independently selectable option (in 
>>> particular, the no-highmem+PAE combination is now valid), but I can't 
>>> see why it added the !HIGHMEM4G dependency.
>> 
>> There's no deep reason, it just has never really been tested that way. I 
>> think we should try it.
>
>If so, what would be the difference between HIGHMEM4G and HIGHMEM64G in
>that case at all?

For example being able to select the DMADEVICES config option.

Jan

