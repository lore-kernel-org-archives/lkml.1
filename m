Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbYGWQJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbYGWQJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYGWQJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:09:42 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:61523 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbYGWQJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SnMrgVQ7R+RZrNzi4KbmFF5CFEfpDVIIIOc0oU18fWDdqTIKL4vlVqT0n/QX1YYXqh
         aDJbWBP1Ntko4KAhldHoVgUkMUAPFd29pVIjQVb4KvUJDJ96Ei0MeGHsNimMUitlPoCD
         NJ65pVhdsvt6WOgx3T9e8B+RM6x3TRqo5cwqg=
Message-ID: <2c0942db0807230909l1e38ed97x9f5ce510dc0dcdd7@mail.gmail.com>
Date: Wed, 23 Jul 2008 09:09:40 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Eric Paris" <eparis@redhat.com>
Subject: Re: request for comment: generic kernel interface for malware vendors
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
In-Reply-To: <1216613887.2960.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216613887.2960.18.camel@localhost.localdomain>
X-Google-Sender-Auth: 9c0902ac42008730
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 9:18 PM, Eric Paris <eparis@redhat.com> wrote:
> 1 - ****hooks, basics, infrastructure
> 2 - configuration generic stuff for the other patches
> 3 - ****results caching
> 4 - exclusions based on the operation or filetype
> 5 - per process exclusions
> 6 - filesystem type exclusions
> 7 - patch exclusions, don't scan when accessed through certain path
> 8 - patch inclusions, only scanning selected things
> 9 - ****userspace vetting, the big stuff
> 10 - operating when userspace is broken

If, along the way, you can also address the needs provided by the
fschange patches (system-wide inotify, in essence, without having to
register individual watches), that'd be gravy. I haven't looked at
either the patches above or the fsnotify ones, so I can't speak to
whatever overlap they may have, except that it certainly seems like
the anti-malware stuff would be a superset.

   http://stefan.buettcher.org/cs/fschange/index.html

~r.
