Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbXI2QAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbXI2QAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 12:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbXI2QAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 12:00:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:8729 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbXI2QAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 12:00:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FeHjBpxlC9AfhlgbGPuROQqsVdbUWbN7Rro8uYUdVQUT3dTyaHyeejqDa//eppiHvi67cD98L84MrmsQtDSAe3Do+9vFlTo15DnYczjay35OHUlbrfGmaEQzYmZnYX/4d2lZBBJLleetkuJGgD2CdOz6KfvnHiUpe1ze0oHXCIc=
Message-ID: <7b69d1470709290859s4dfcb6x8827dd20a4e55b34@mail.gmail.com>
Date: Sat, 29 Sep 2007 10:59:57 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Erez Zadok" <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 1/3] CodingStyle updates
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Adrian Bunk" <bunk@kernel.org>, roel <12o3l@tiscali.nl>
In-Reply-To: <11910151223447-git-send-email-ezk@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
	 <11910151223447-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of comments interspersed...

On 9/28/07, Erez Zadok <ezk@cs.sunysb.edu> wrote:
...
>  There are a number of driver model diagnostic macros in <linux/device.h>
>  which you should use to make sure messages are matched to the right device
---

I think this "which" is non-restrictive, so it should have a comma
after it (I realize that's not part of your patch). It's also possible
to read it as restrictive, in which case "that" would be preferable.

---
>  and driver, and are tagged with the right level:  dev_err(), dev_warn(),
> -dev_info(), and so forth.  For messages that aren't associated with a
> -particular device, <linux/kernel.h> defines pr_debug() and pr_info().
> +dev_info(), and so forth.
> +
> +A number of people often like to define their own debugging printf's,
---

"A number of people often like to..." is awkward. How about
"Developers sometimes..." or "Too many people..."

---
> +wrapping printk's in #ifdef's that get turned on only when subsystem

> +               Chapter 19: branch prediction optimizations
> +
> +The kernel includes macros called likely() and unlikely(), which can be used
---

You might say "The kernel provides the macros likely()..."

---
> +as hints to the compiler to optimize branch prediction.  They operate by
...
> +A good example of this is the above kmalloc(GFP_KERNEL) call.  The chances
> +of kmalloc() returning NULL are rather small, because even if it doesn't
> +have memory to return to you at the moment, with GFP_KERNEL/__GFP_WAIT
> +passed, kmalloc() will wait and suspend your thread, while it goes off to
---

The commas after "passed" and "thread" is unnecessary.

---
> +find some free memory (purging caches, flushing buffers, etc.).  In other
> +words, kmalloc() tries very hard to give you the memory you asked for by the
> +time it return.
---

"...by the time it return." should be "...by the time it returns."

---
> +
> +Consider the next, bad example.  Suppose you're developing a file system
> +which performs logically different actions on different types of entities:
---

This "which" is restrictive; it would be preferable to use "that" instead.

---
> +files, directories, symlinks, devices, etc. and you use this code:
> +
...
> +be penalized heavily for going [sic] down the wrong path...  Therefore, you
> +should consider also whether a seemingly-rare condition is indeed rare ALL
---

The hyphen isn't necessary when the first word of the compount
adjective is an adverb ending in "-ly", so, just "seemingly rare"; or
switch to "apparently rare".

---
> +the time.
...


-- 
scott preece
