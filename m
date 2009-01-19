Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbZASO25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbZASO25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZASO2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:28:45 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:57037 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbZASO2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:28:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WLf/FB6aOy1MT8vBSIvMiaNc6GiYlcJslaKunX72fNIAJ8M51II9BMYSBAtCh5TZph
         bxa8TeLRU8HFTkQslb11ZMeIfQftGGhcjw1bjzWPWADjeFbHOSAMf424rilgb1cW47rc
         xIchE1XLUWAC8zVMZb59QLZvFPIxDOGwD0BvQ=
MIME-Version: 1.0
In-Reply-To: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>
Date: Mon, 19 Jan 2009 06:28:42 -0800
Message-ID: <3aa654a40901190628p1c17e4d6w61c114cdb7cc0155@mail.gmail.com>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due 
	to dc1e35c
From: Avuton Olrich <avuton@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 6:04 AM, Avuton Olrich <avuton@gmail.com> wrote:
> Hello,
>
> My computer fails to make it past 'Unpacking kernel' with anything
> later than dc1e35, to at least v2.6.29-rc2 due to dc1e35c, at least so
> git bisect told me. While writing this bug I discovered I was using
> gcc-4.1.1 when I thought I was using gcc-4.3.2; I upgraded, recompiled
> 2.6.28.1 and same results so I assume the same results would come from
> me doing the 4 hour bisect again.

I was inaccurate, It did not print 'Unpacking kernel', it was 'Booting
the kernel'.
-- 
avuton
--
|  (\_/)  This is Bunny. Copy and paste Bunny
| (='.'=) into your signature to help him gain
| (")_(") world domination.
