Return-Path: <linux-kernel-owner+w=401wt.eu-S1161216AbXDKG12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161216AbXDKG12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 02:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXDKG12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 02:27:28 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54229 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1161216AbXDKG11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 02:27:27 -0400
Message-ID: <376272831.09174@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 11 Apr 2007 14:23:49 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Cong WANG <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 patch]Warning fix: check the return value of kobject_add etc.
Message-ID: <20070411062349.GA5843@mail.ustc.edu.cn>
Mail-Followup-To: Cong WANG <xiyou.wangcong@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <2375c9f90703301930k4963168u4ba4dbc4c43ce2ee@mail.gmail.com> <20070331223136.6019d98f.akpm@linux-foundation.org> <2375c9f90703312320m3e895bbap735c2d49da9d5ff9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2375c9f90703312320m3e895bbap735c2d49da9d5ff9@mail.gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2007 at 02:20:46PM +0800, Cong WANG wrote:
> 2007/4/1, Andrew Morton <akpm@linux-foundation.org>:
> >
> >Also, please always prepare patches in `patch -p1' form, as per
> >http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt, thanks.
> >
> >
> 
> Sorry. I am confused with this. Does that mean I should make patches
> _upon_ the root kernel source directory or first make a copy of the
> original source code and then diff against the two dirs? But I was
> told that "patches should be based _in_ the root kernel source
> directory" and when only one file was modified just to diff it with
> the original single file. (See Documentation/SubmittingPatches.)
> 
> Can you help out? And should I remake this patch? Thanks again!

quilt(http://savannah.nongnu.org/projects/quilt) is your friend.

cd /usr/src/linux
quilt new my-fix.patch
quilt edit mm/readahead.c
quilt refresh --diffstat
quilt diff
...
