Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbXIBJ63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbXIBJ63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 05:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbXIBJ6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 05:58:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbXIBJ6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 05:58:19 -0400
Message-ID: <46DA88EF.7080103@zytor.com>
Date: Sun, 02 Sep 2007 10:57:03 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: David Kastrup <dak@gnu.org>
CC: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.3
References: <7vodglr32i.fsf@gitster.siamese.dyndns.org>	<46DA5F33.2020005@zytor.com> <85odgltrtj.fsf@lola.goethe.zz>
In-Reply-To: <85odgltrtj.fsf@lola.goethe.zz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Kastrup wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> Junio C Hamano wrote:
>>> * For people who need to import from Perforce, a front-end for
>>>   fast-import is in contrib/fast-import/.
>>>
>> There seems to be an issue with this and RPMS.
>>
>> In particular, there is no longer a git-p4 RPMS, which prevents git
>> from getting upgraded at all by yum.
>>
>> Anyone who knows yum well enough to explain what needs to be done so
>> that yum knows this is obsolete?
> 
> Probably a matter of the correct spec file.  In auctex.spec, we have
> 

 From the looks of it, there is still a git-p4, it just moved to contrib 
and uses fast-import, so removing its rpm package was probably broken in 
the first place.

"make rpm" is also broken for "dirty" builds, which is bad for testing.

	-hpa
