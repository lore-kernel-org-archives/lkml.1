Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYHNPkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYHNPkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYHNPkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:40:12 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:49367 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbYHNPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=c1VJQ4X8nnUPqEOz8eiNh4x8EaqAh+dKgSaUh7d7QhF/MiY5z2Sxk7WeLz4Bu7qldh
         RRfYYsg2vzsUr7ya4LiY9r747a44ZBMznjoqJwBQbwwVt10qq6T6ZSjg5vAl1cUI2xQd
         3xe0YVP4E7ftYoN/b7SQM+HApDiEapnR5wzzA=
Message-ID: <b3ece790808140840t214ccbq6db63c33b4ebe963@mail.gmail.com>
Date: Thu, 14 Aug 2008 08:40:06 -0700
From: "Tim Hockin" <thockin@hockin.org>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
Cc: "Jan Kara" <jack@suse.cz>, "Pavel Machek" <pavel@ucw.cz>,
       lf_kernel_messages@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, "Joe Perches" <joe@perches.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "=?UTF-8?Q?Jochen_Vo=C3=9F?=" <jochen.voss@googlemail.com>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Kunai Takashi" <kunai@linux-foundation.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       linux-s390@vger.kernel.org, "Gerrit Huizenga" <gh@us.ibm.com>,
       "Michael Holzheu" <holzheu@de.ibm.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Tim Bird" <tim.bird@am.sony.com>, "Tim Hockin" <thockin@hockin.org>
In-Reply-To: <200808141153.03269.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080730165656.118280544@de.ibm.com>
	 <200808131433.02966.rusty@rustcorp.com.au>
	 <b3ece790808130004p4763b11fveaf4c8380c7c86f7@mail.gmail.com>
	 <200808141153.03269.rusty@rustcorp.com.au>
X-Google-Sender-Auth: 9a4c2abaf063e8ed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 13, 2008 9:15 PM, "Rusty Russell" <rusty@rustcorp.com.au> wrote:

> On Wednesday 13 August 2008 17:04:11 Tim Hockin wrote:
>> But there are a number of places that have ...Well, if they're to be the
>> same messages under the manual-numbering scheme,
>
> someone has to verify that they are really the same anyway.  Not much more
> work to simply fix them in that case, is it?
>
> If it improves normal kernel messages, then everyone wins.

Oh, I agree with that.  I personally don't care much for the msg ID part of
this patch (I mean I don't care either way).  It might be nice to have man
pages, but I just see it becoming out of sync, duplicate numbers, etc.

What I want to see is the elevation of these call-sites from "it's just a
printk()" to "it's a report-worthy event and part of our user<->kernel API".  I
want people to add them when it's appropriate and then not change the strings
later.  I don't care if, in the end, they are structured strings.  I do care if
I have to run dozens of regexes against thousands of log-lines on thousands of
systems.

:)

Tim
