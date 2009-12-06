Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbZLFXtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbZLFXtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbZLFXtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:49:40 -0500
Received: from mbox1.netikka.net ([213.250.81.202]:54649 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779AbZLFXtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:49:39 -0500
X-Greylist: delayed 1522 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Dec 2009 18:49:39 EST
Message-ID: <4B1C3D25.4010903@mandriva.org>
Date: Mon, 07 Dec 2009 01:24:21 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [stable] x86: Remove STACKPROTECTOR_ALL
References: <200911021859.nA2Ix4cB023712@hera.kernel.org> <4AF9E7D4.9080309@mandriva.org> <20091205195852.GC21172@kroah.com>
In-Reply-To: <20091205195852.GC21172@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH skrev:
> On Wed, Nov 11, 2009 at 12:23:16AM +0200, Thomas Backlund wrote:
>> I think this one should go to 2.6.31.x too ...
>>
>>> Gitweb:     http://git.kernel.org/linus/14a3f40aafacde1dfd6912327ae14df4baf10304
>>> Commit:     14a3f40aafacde1dfd6912327ae14df4baf10304
>>> Parent:     02dd0a0613e0d84c7dd8315e3fe6204d005b7c79
>>> Author:     Arjan van de Ven <arjan@infradead.org>
>>> AuthorDate: Fri Oct 23 07:31:01 2009 -0700
>>> Committer:  Ingo Molnar <mingo@elte.hu>
>>> CommitDate: Fri Oct 23 16:35:23 2009 +0200
>>>
>>>     x86: Remove STACKPROTECTOR_ALL
>>>     
>>>     STACKPROTECTOR_ALL has a really high overhead (runtime and stack
>>>     footprint) and is not really worth it protection wise (the
>>>     normal STACKPROTECTOR is in effect for all functions with
>>>     buffers already), so lets just remove the option entirely.
>>>     
>>>     Reported-by: Dave Jones <davej@redhat.com>
>>>     Reported-by: Chuck Ebbert <cebbert@redhat.com>
>>>     Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>>>     Cc: Eric Sandeen <sandeen@redhat.com>
>>>     LKML-Reference: <20091023073101.3dce4ebb@infradead.org>
>>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> It doesn't really "fix" anything, so I'd prefer not too.
> 

The reason for I suggested it was that is's supposed to remove some
bloating, and reportedly xfs from blowing up:

http://marc.info/?l=linux-kernel&m=125614028227106&w=2

But anyway, it's your call...

--
Thomas

