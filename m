Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbYDJSDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbYDJSDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 14:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbYDJSDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 14:03:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:36021 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbYDJSDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 14:03:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=byr4tyCxuCo+rc/fwqDoJuPW89chcepOJ+OTZfckftv4GEMkUZp8ToxyUK5fDsWT+tucDmTvn2gprPnd8TNBLprQJ/42i5Fof5WFpS7ENMlpkQOywTsTmxe3DIUy4KDam+W7W58guxnT4yIT2Li/11k/B7exC6Sf3U+r5f3pT2k=
Message-ID: <e2e108260804101102tfc21271id2b71429ac5b5b6@mail.gmail.com>
Date: Thu, 10 Apr 2008 20:02:58 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Jack Harvard" <jack.harvard@googlemail.com>
Subject: Re: gettimeofday() resolution in Linux?
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a72f6a3c0804101057i10c572bak1dd09f0c7fd75d30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a72f6a3c0804100740s687beacbh80653107f4a7b702@mail.gmail.com>
	 <20080410150424.GD2160@csclub.uwaterloo.ca>
	 <a72f6a3c0804100859w4181d84ak1a63e7dec4d5b42f@mail.gmail.com>
	 <e2e108260804101041k411b5fcfgc418f4be1bf7edba@mail.gmail.com>
	 <a72f6a3c0804101057i10c572bak1dd09f0c7fd75d30@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 7:57 PM, Jack Harvard
<jack.harvard@googlemail.com> wrote:
> On Thu, Apr 10, 2008 at 6:41 PM, Bart Van Assche
>  <bart.vanassche@gmail.com> wrote:
>  > On Thu, Apr 10, 2008 at 5:59 PM, Jack Harvard
>  > <jack.harvard@googlemail.com> wrote:
>  >
>  > >  Here is an example of gettimeofday results, the time rolls back sometimes.
>  >
>  >  If the result of gettimeofday() rolls back, and there is no process on
>  >  your system that sets the time (like ntpd or hwclock --hctosys) then
>  >  this is a kernel bug. Which kernel version are you using, and which
>  >  kernel patches have been applied to that kernel ?
>
>  It's an embedded system with an ARM processor, uname -a give the following info:
>  Linux (none) 2.6.21-arm1-t2_1 #20 Thu Apr 10 15:20:46 BST 2008 armv6l unknown

Where did the kernel sources come from -- from kernel.org or from an
company that modified the kernel ? Most companies that offer support
for Linux on embedded devices modify the kernel with e.g. hard
real-time support and high resolution timers. It is easy to introduce
bugs by doing so.

Bart.
