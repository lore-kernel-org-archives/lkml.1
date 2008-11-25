Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYKYQ1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYKYQ1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKYQ1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:27:36 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:37449 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYKYQ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:27:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=eZKUvLeq7zVygC7y/VIKfKdmMQ0TaqZrF2ZvbhTz4OiZXOe9LhMSVYD/dcURuVsmLe
         Kj2xQWJ5WIrdHJBxo9mAxSnLuNn6XtuKfvbT3OnHdMbswIk6a/7Uy+kzv5IO7s2NpoP2
         xBE+tsexVwPz+BRD2ooDxMqsZhXaqfFeGv8/w=
Message-ID: <cfd18e0f0811250827q71b4f07l33821d004f27adf3@mail.gmail.com>
Date: Tue, 25 Nov 2008 11:27:33 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: Documentation for CLONE_NEWPID
Cc: "Kir Kolyshkin" <kir@openvz.org>, linux-man@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <492C1FCB.1080405@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4923810B.7010201@gmail.com> <492AA241.6050004@openvz.org>
	 <cfd18e0f0811250746i711205dej6b98f2fba6cecc42@mail.gmail.com>
	 <492C1FCB.1080405@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

[...]

>> *** Here's where I make the point about each process having multiple PIDs"
>>
>>>> +The existence of a namespace hierarchy means that each process
>>>> +may now have multiple PIDs:
>>>> +one for each namespace in which it is visible.
>>
>> I added some words here:
>>
>> "each of these PIDs is unique within the corresponding namespace".
>
> Correct.

Thanks for the ACK.

>>>> +(A call to
>>>> +.BR getpid (2)
>>>> +always returns the PID associated with the namespace in which
>>>> +the process was created.)
>>> I don't thinks it's a good example - the getpid cannot be called
>>> for other process other than current :)
>>
>> It wasn't meant as an example.  The point was, with a process
>> potentially being a member of multiple namespaces, the reader might
>> wonder: what does getpid(2) return?  This sentence was intended to
>> clarify that.  With that explanation, does this sentence now seem
>> okay?
>
> Yes, but I'd change "was created" into "lives in". From my POV this
> sounds more clear. I do not insist however :)

Done.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
