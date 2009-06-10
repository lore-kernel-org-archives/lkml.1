Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbZFJSEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbZFJSEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 14:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbZFJSD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 14:03:59 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:38032 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZFJSD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 14:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=b8rZl56fV+r0uUDrn4K3AfLCgzHu10iZC0az39bHbfIeIkaucq9qT9xbjjCKKKERNN
         W0kEioLhl9dHLQKQic6Aee2HLLUIvfyhpxA2ND+grlmrzY3hoglDn6ZRf9UOfiz/JZxc
         MSlS86OiNfTPTA2qMvro4HPZ1IAajVSq/HHFY=
MIME-Version: 1.0
In-Reply-To: <20090610155626.GA7951@csn.ul.ie>
References: <4A2BBC30.2030300@lwfinger.net> <4A2BCC6F.8090004@redhat.com>
	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	 <20090608101739.GA15377@csn.ul.ie>
	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
	 <20090608110303.GD15377@csn.ul.ie>
	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
	 <20090608141212.GE15070@csn.ul.ie>
	 <1244531201.5024.3.camel@penberg-laptop>
	 <20090610155626.GA7951@csn.ul.ie>
Date: Wed, 10 Jun 2009 21:03:59 +0300
X-Google-Sender-Auth: 989be23167751330
Message-ID: <84144f020906101103ncad6dc9q23783b175ae12792@mail.gmail.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 6:56 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> That looks like it would generate easier-to-debug-with messages and to
> not-expert-at-slub eye, it looks correct. Slap a changelog on it with an
> example message and go with it.  It should make page allocation failures
> messages that go through SLUB a lot easier to figure out.

Thanks Mel! The patch is here and will be part of next slab pull
request to Linus:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=4bc6e7858da5ea4ecc3e47538f7fabed331cc21b
