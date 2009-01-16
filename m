Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbZAPAoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbZAPAoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZAPAoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:44:19 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:57778 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbZAPAoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:44:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=scJmtFnykKt2PsOFFZb8ZkBXj965XVo18FeQEkus39FO9X3j3loOTLI+4zl/Y1KerK
         9ew6ff11tcvzJSS+OEXF5+6nq3SN3ZvT0fJwDOrwBZJvAqULnQyqGTP6VkyOfr6cYHJY
         KTm1QO9C/8oVgz4A7taApaUn7djhxKy4/qtV8=
Message-ID: <dd18b0c30901151644q4578f7d6k3023cad6f05325dd@mail.gmail.com>
Date: Thu, 15 Jan 2009 16:44:15 -0800
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Paul Moore" <paul.moore@hp.com>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       SE-Linux <selinux@tycho.nsa.gov>
In-Reply-To: <200901151752.06622.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496D759A.7010401@gmail.com> <200901151246.38396.paul.moore@hp.com>
	 <dd18b0c30901151400t68dfc54cu67a378ba71a2edc9@mail.gmail.com>
	 <200901151752.06622.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 2:52 PM, Paul Moore <paul.moore@hp.com> wrote:
> On Thursday 15 January 2009 5:00:55 pm Justin Mattock wrote:
>> On Thu, Jan 15, 2009 at 9:46 AM, Paul Moore <paul.moore@hp.com> wrote:
>> > On Wednesday 14 January 2009 9:43:56 pm Justin P. Mattock wrote:
>> >> Paul Moore wrote:
>> >> > On Wednesday 14 January 2009 4:35:25 pm Justin P. Mattock wrote:
>> >> >> here is what the error looks like:
>> >> >>
>> >> >> netlabel_tools-0.19# make
>> >> >> INFO: creating the version header file
>> >> >> .: 10: version_info: not found
>> >> >> make: *** [include/version.h] Error 2
>> >> >
>> >> > Huh, can you try the following:
>> >> >
>> >> >  1. Open the netlabel_tools-0.19/Makefile in your favorite
>> >> > editor 2. Change the ". version_info; \" line to "source
>> >> > ./version_info; \" 3. Save your changes
>> >> >  4. Try running "make" again
>> >> >
>> >> > Thanks.
>> >>
>> >> O.k. changed . version like how you had posted.
>> >> The package compiled like a charm.
>> >
>> > Great, I'll change the Makefile(s) in SVN ... I don't quite
>> > understand the reason (what is your /bin/sh?  I'm guessing not
>> > bash?) but at least we now have a solution :)
>> >
>> > --
>> > paul moore
>> > linux @ hp
>>
>> hmm..
>> under ps auxZ
>> I see:
>> 2896 tty1 S+ 0:00 /bin/bash /usr/bin/startx
>> then open aterm for navigating.
>>
>> Thankfully it works(this people can install
>> it a test it out.)
>
> Well, it is possible that /bin/sh points to a non-bash shell but maybe
> not (I'm pretty sure the make command executes the scripts
> with /bin/sh).  Either way, I checked in the fix to the SVN tree
> earlier today so newer releases will have the fix; if needed I can
> release a 0.19.1 or similar but I want to wait and see how widespread
> the problem is ...
>
> --
> paul moore
> linux @ hp
>

Cool, If I see anybody
struggling, I point them to the
fix you posted.
I also might be missing something, i.g.
one of the boxes that gave this error I built
with debootstrap, but then the other that gave this as well
was built with nubuntu which seems more complete
than debootstrap.
but then maybe both are missing a package.
(or it's a debian thing)

regards;

-- 
Justin P. Mattock
