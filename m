Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbXDKGpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbXDKGpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 02:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933140AbXDKGpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 02:45:13 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:58684 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069AbXDKGpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 02:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LmGANoGQh1ZNniZHUS0NaUJNtHT67+8SspvS6HQ2YxwyOOwCSnQ6Z3zKCWnpO9QYMHU3+ysyAI88gy22wF5APjXRnn3peSVY3ZZj5NUojuu1EJHeHV3VDJmgpgxmrzRBW8BJkJXS4Tm7Y8TDu+dsHm1iNi8Qd9DaylpOPxbPlvw=
Date: Wed, 11 Apr 2007 14:48:30 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 patch]Warning fix: check the return value of kobject_add etc.
Message-ID: <20070411064830.GA4595@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <2375c9f90703301930k4963168u4ba4dbc4c43ce2ee@mail.gmail.com> <20070331223136.6019d98f.akpm@linux-foundation.org> <2375c9f90703312320m3e895bbap735c2d49da9d5ff9@mail.gmail.com> <20070411062349.GA5843@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411062349.GA5843@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 02:23:49PM +0800, Fengguang Wu wrote:
>On Sun, Apr 01, 2007 at 02:20:46PM +0800, Cong WANG wrote:
>> 2007/4/1, Andrew Morton <akpm@linux-foundation.org>:
>> >
>> >Also, please always prepare patches in `patch -p1' form, as per
>> >http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt, thanks.
>> >
>> >
>> 
>> Sorry. I am confused with this. Does that mean I should make patches
>> _upon_ the root kernel source directory or first make a copy of the
>> original source code and then diff against the two dirs? But I was
>> told that "patches should be based _in_ the root kernel source
>> directory" and when only one file was modified just to diff it with
>> the original single file. (See Documentation/SubmittingPatches.)
>> 
>> Can you help out? And should I remake this patch? Thanks again!
>
>quilt(http://savannah.nongnu.org/projects/quilt) is your friend.
>
>cd /usr/src/linux
>quilt new my-fix.patch
>quilt edit mm/readahead.c
>quilt refresh --diffstat
>quilt diff
>...

Thanks. I will try it. ;-)

