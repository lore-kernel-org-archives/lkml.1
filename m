Return-Path: <linux-kernel-owner+w=401wt.eu-S1761992AbYG3MWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992AbYG3MWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761777AbYG3MWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:22:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:6005 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761759AbYG3MWV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=ROpAgiFlkcAw84wugUDdnbIsB7npsXw45vJGxyJ4U3o+kFY8BbaoK5Br9ZowAl84dk
         EaKb/5PK/Gh7Ke2+9Uii9aHUAnbzGPDjcnC1l2mu1xzx3TT+rh/7R5/uYth3iVLj6hK/
         4NgIhhaZlHe8gyulnr4/hDltenPWIGoJX4E9w=
Message-ID: <9ea470500807300522s6f1c1ab2qdd0f5eb45616d594@mail.gmail.com>
Date: Wed, 30 Jul 2008 14:22:20 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 1/5] docsrc: build Documentation/ sources
Cc: "Randy Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080730112136.GA19465@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <12173619152424@xenotime.net> <20080729202732.GB6007@gollum.tnic>
	 <20080730084405.GD18366@uranus.ravnborg.org>
	 <9ea470500807300155t60732956m67d196f87aed9fa4@mail.gmail.com>
	 <20080730112136.GA19465@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 1:21 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> >
>> > With the current approach we have much better build coverage.
>> > All "allyesconfig" and "allmodconfig" builds will do the test
>> > builds which is a good think.
>> > If we introduce "make docsrc" then almost only Randy will do the
>> > test builds and report the breakage - which is not good.
>>
>> Well, i don't see anymore people than Randy doing
>>
>> CONFIG_BUILD_DOCSRC=1 make ...
>
> One such example is:
> http://kisskb.ellerman.id.au/linux-next
>
> Here the all*config will do the build test of the
> documentation and Stephen will tell if it breaks.
>
>> either so only the other option remains, which means CONFIG_BUILD_DOCSRC
>> should be "default y" for more coverage...
> No - we do not want to set config options to "default y" unless
> there are _very_ good reasons to do so.

Sorry, I had to think about it a bit to realize what you were implying -  the
all(yes|mod)config targets _will_ turn on the CONFIG_BUILD_DOCSRC option
so no need for the 'default y' setting, which seems pretty silly for
that case anyway.

-- 
Regards/Gruﬂ,
Boris
