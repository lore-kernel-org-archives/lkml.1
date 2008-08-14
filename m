Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYHNEPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYHNEPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 00:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYHNEOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 00:14:55 -0400
Received: from ozlabs.org ([203.10.76.45]:32834 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYHNEOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 00:14:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Tim Hockin" <thockin@hockin.org>
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
Date: Thu, 14 Aug 2008 11:53:01 +1000
User-Agent: KMail/1.9.9
Cc: "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael Holzheu" <holzheu@de.ibm.com>,
       "Gerrit Huizenga" <gh@us.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Jan Kara" <jack@suse.cz>,
       "Pavel Machek" <pavel@ucw.cz>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Joe Perches" <joe@perches.com>,
       "Jochen =?utf-8?q?Vo=C3=9F?=" <jochen.voss@googlemail.com>,
       "Kunai Takashi" <kunai@linux-foundation.jp>,
       "Tim Bird" <tim.bird@am.sony.com>
References: <20080730165656.118280544@de.ibm.com> <200808131433.02966.rusty@rustcorp.com.au> <b3ece790808130004p4763b11fveaf4c8380c7c86f7@mail.gmail.com>
In-Reply-To: <b3ece790808130004p4763b11fveaf4c8380c7c86f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808141153.03269.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008 17:04:11 Tim Hockin wrote:
> But there are a number of places that have different strings for the
> same meaning: "Can't" vs "can't" vs "can not" vs "failed to", etc.
>
> This is a big part of what hurts us - you end up with lots of loose
> regexes when parsing logs.

Well, if they're to be the same messages under the manual-numbering scheme, 
someone has to verify that they are really the same anyway.  Not much more 
work to simply fix them in that case, is it?

If it improves normal kernel messages, then everyone wins.
Rusty.
