Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZAKPbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZAKPbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZAKPbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:31:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:46656 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZAKPbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:31:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GN1MJ7+JlClW5pxr7QMU/3Wlp1mb2lJMKrb9Wa2FB/h6dYIZKF16dxBIWzMm/9a202
         AiME8UBbnnoT/uLzgBF2DyGHVD6Xh9u9jNQVdvozm3YEWCdUsAFiqDp9sW1wuh6RMjLA
         NXCXL4qnOWUblUU1ZrXeQolon57KCRWNOw5FQ=
Message-ID: <170fa0d20901110731w7e1e3b1dvf880e9639411dbb7@mail.gmail.com>
Date: Sun, 11 Jan 2009 10:31:09 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Andreas Dilger" <adilger@sun.com>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Cc: "Theodore Tso" <tytso@mit.edu>, "Ingo Molnar" <mingo@elte.hu>,
       "Nicholas Miell" <nmiell@comcast.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "jim owens" <jowens@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Matthew Wilcox" <matthew@wil.cx>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Nick Piggin" <npiggin@suse.de>,
       "Peter Morreale" <pmorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, sam@ravnborg.org,
       "Dave Anderson" <anderson@redhat.com>
In-Reply-To: <20090111101135.GA3306@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com>
	 <20090110153446.GA13976@elte.hu>
	 <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com>
	 <20090110211531.GD31579@mit.edu>
	 <20090111101135.GA3306@webber.adilger.int>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 5:11 AM, Andreas Dilger <adilger@sun.com> wrote:
> On Jan 10, 2009  16:15 -0500, Theodore Ts'o wrote:
>> In my experience, there are very few kernel versions and hardware for
>> which kdump works.  I've talked to the people who have to make kdump
>> work, and every 12-18 months, with a new set of enterprise kernels
>> comes out, they have to go and fix kdump so it works again for the set
>> of hardware that they care about, and for the kernel version involved.
>
> I'm sad that netconsole/netdump never made it big.  It was fairly useful,
> and extending the eth drivers to add the polling mode was trivial to do.
> We were using that for a few years, but it got replaced by kdump and it
> appears to be less usable IMHO.

Less usable in terms of ease of configuration and use?  Or
reliability?  In practice netdump's non-interrupt-driven polling mode
proved fairly reliable but it seems to me kdump provides more reliable
dumping than netdump.  Because you're performing the kdump from a
reliable new dump kernel (provided the initial kexec transition to the
dump kernel works properly).

Mike
