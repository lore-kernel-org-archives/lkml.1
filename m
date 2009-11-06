Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZKFWD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZKFWD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758757AbZKFWDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:03:25 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:55533 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666AbZKFWDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:03:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WBpRYblOg+X5PQWQEnFW5trX+gLYXYU7RCv97QWwqlbixzEHfo4BFbQ4lhiXpdr3yM
         sXF6AOHU6TGkb5J7he7PhS2pa/VRkg1sLWLo2A560ZRxnZ9vSGZvxUcXch1olsiSGn22
         kwc75GKZ7+GX3zS3QbXwzKjOIqwENWCgM/PPA=
MIME-Version: 1.0
In-Reply-To: <364299f40911061339x7b689d3cw705674bd9b332e5c@mail.gmail.com>
References: <1257167821.4977.41.camel@subratamodak.linux.ibm.com>
	 <87iqdn76jg.fsf@basil.nowhere.org>
	 <364299f40911061339x7b689d3cw705674bd9b332e5c@mail.gmail.com>
Date: Fri, 6 Nov 2009 14:03:30 -0800
Message-ID: <364299f40911061403ied57cc5w2120a8ea8c9a8c72@mail.gmail.com>
Subject: Re: [LTP] [ANNOUNCE] The Linux Test Project has been Released for 
	OCTOBER 2009
From: Garrett Cooper <yanegomi@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: subrata@linux.vnet.ibm.com, ltp-list <ltp-list@lists.sf.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 1:39 PM, Garrett Cooper <yanegomi@gmail.com> wrote:
> On Fri, Nov 6, 2009 at 12:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> Subrata Modak <subrata@linux.vnet.ibm.com> writes:
>>>
>>> ========================
>>> OCTOBER 2009 Highlights:
>>
>> s/High/Low/
>>
>>> ========================
>>>      1. LTP Makefiles rewrite:(Project started 1.2 years back)
>>>              I. To accommodate correct build/installation practices,
>>>             II. better integrate Autoconf/Automake with tests for safer
>>>                 builds,
>>>            III. better cross-compilation of LTP sources.
>>
>> Just as a warning for everyone: that change broke building on most old
>> distributions and there seems to be no interest in fixing that.
>>
>> Unless you're running the latest and greatest better stay with older LTP
>> versions.
>
> Andi,
>    Let's keep this discussion on track with the other thread that's
> open. We can probably come to an engineering solution that will allow
> your version of make (3.80) to function, but I think that a line needs
> to be drawn in the sand at that version because make 3.79 is too
> ancient (~7 years old) to work with.

    Andi and Arjen did make a valid point in the other thread. If you
do not have access to make 3.81, please avoid this release. I will
work on filling in the gaps for 3.80 to function, but users with make
3.79 will need to upgrade to either 3.80 or 3.81.
Thanks,
-Garrett
