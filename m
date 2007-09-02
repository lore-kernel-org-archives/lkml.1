Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbXIBUEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbXIBUEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXIBUEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:04:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:37396 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXIBUEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ccN8bC+6MWiR4Xj4eGdqjb/Dd7Hmxg5PGRrEgbG9+qtxbQx5FEfZac5W5Z0PgEjz5r06vUlH97MoJYxx4yckapsuu81IJDzyOy6qzVCnW7AgYplagv1oexnJ0ATX5GcqYbC+yI+9Du2asssWh1pRbm/kIbu/g5iBy96hHRSZNCw=
Message-ID: <9a8748490709021304k37d7e42clc32a08d5ec0f4a75@mail.gmail.com>
Date: Sun, 2 Sep 2007 22:04:37 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Satyam Sharma" <satyam@infradead.org>
Subject: Re: [-mm patchset] War on warnings
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/07, Satyam Sharma <satyam@infradead.org> wrote:
>
> I decided to ruin my Sunday with an utterly pointless activity --
> waging war on -mm build warnings. Some of the code I touched belonged
> to grotty, unused, dying drivers, but still, the end result was that
> I can now only see 5 warnings remaining on my typical .config (those
> have to do with pci_{find,enable}_device deprecation and __must_check
> on sysfs_create_{file,link} so I'll just leave 'em for now).
>
> Some were unused variable warnings, some uninitialized (few of those
> real bugs, but most not), some were "function defined but not used",
> some function argument signedness mismatches, some __must_check fixes,
> some tricky, but most just trivial.
>
> So till the next kernel release adds back shiny new build warnings,
> here's to some temporary peace ...

Great work Satyam.

Personally I hate all the build warnings we get and, just like you,
once in a while go on a warning killing spree. It's just so much
easier to spot the real problems when the build doesn't spew a ton of
pointless warnings.

Thank you for doing this, I hope some of your patches get merged.

Btw; it would be easier to see if one has got all the patches if you
numbered your patch series with the usual "[PATCH XX/YY]".

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
