Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYIHSO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYIHSO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYIHSOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:14:50 -0400
Received: from gw.goop.org ([64.81.55.164]:36163 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbYIHSOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:14:50 -0400
Message-ID: <48C56B99.9020307@goop.org>
Date: Mon, 08 Sep 2008 11:14:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rambaldi <rambaldi@xs4all.nl>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 xen balloon driver warnings
References: <48C0F09C.1000101@xs4all.nl> <48C457DC.9050904@goop.org> <48C546B2.50108@xs4all.nl> <48C558D9.9030006@goop.org> <20080908180126.GB29264@elte.hu>
In-Reply-To: <20080908180126.GB29264@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Rambaldi wrote:
>>     
>>> I used the complete patch, I had some compile warnings.
>>>       
>> Well, the compile warning are bad news.  Just use the first hunk.
>>
>> Ingo, could you send this up to Linus?  It's a subset of a patch you've
>> already got in your tree.
>>     
>
> i cherry-picked the whole thing as that's the tested commit. Is that 
> fine too?

No, because it caused compile-time warnings.  The signatures on sysfs
access functions changed, so that patch will break unless the rest of
the sysfs changes went in.

    J
