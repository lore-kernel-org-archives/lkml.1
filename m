Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYG3I4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYG3I4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYG3Izy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:55:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:36589 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYG3Izx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=t7WNY1xZbDQEbfC89hYwiv4WwlZpZXZfdzk9/pU5f2ai3jmmtv6G3EI5sbsXKdLE1G
         NK0/A3E4kLns3PQaqtguJm8+hrlHKwUlUht4tey/KVNsrF8A5zN6Pryt4+tkU4p/JrP4
         Dgx4DN9No8zTguPjL1fsnkJcXkVl0NNsKu2Bc=
Message-ID: <9ea470500807300155t60732956m67d196f87aed9fa4@mail.gmail.com>
Date: Wed, 30 Jul 2008 10:55:52 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 1/5] docsrc: build Documentation/ sources
Cc: "Randy Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20080730084405.GD18366@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <12173619152424@xenotime.net> <20080729202732.GB6007@gollum.tnic>
	 <20080730084405.GD18366@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 10:44 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Tue, Jul 29, 2008 at 10:27:32PM +0200, Borislav Petkov wrote:
>> On Tue, Jul 29, 2008 at 01:05:15PM -0700, Randy Dunlap wrote:
>> > From: Randy Dunlap <randy.dunlap@oracle.com>
>> >
>> > Currently source files in the Documentation/ sub-dir can easily bit-rot
>> > since they are not generally buildable, either because they are hidden
>> > in text files or because there are no Makefile rules for them.
>> > This needs to be fixed so that the source files remain usable and good
>> > examples of code instead of bad examples.
>> >
>> > Add the ability to build source files that are in the Documentation/ dir.
>> > Add to Kconfig as "BUILD_DOCSRC" config symbol.
>> >
>> > Use "CONFIG_BUILD_DOCSRC=1 make ..." to build objects from the
>> > Documentation/ sources.  Or enable BUILD_DOCSRC in the *config system.
>>
>> How about simply adding another makefile target instead? This is more
>> intuitive, imho, and complies with the Kbuild conventions so far.
>> Something like:
>>
>> make docsrc
>>
>> similar to 'make help' or 'make pdfdocs' etc.
>
> With the current approach we have much better build coverage.
> All "allyesconfig" and "allmodconfig" builds will do the test
> builds which is a good think.
> If we introduce "make docsrc" then almost only Randy will do the
> test builds and report the breakage - which is not good.

Well, i don't see anymore people than Randy doing

CONFIG_BUILD_DOCSRC=1 make ...

either so only the other option remains, which means CONFIG_BUILD_DOCSRC
should be "default y" for more coverage...


-- 
Regards/Gruﬂ,
Boris
