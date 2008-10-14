Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYJNWMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYJNWMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYJNWMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:12:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:5829 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbYJNWMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:12:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZEPRnhJNG5dD6s39EH/rym0nVZ3dH1g2V3i3FxITIB3F0wc3LM51g70w2ixUtZZJ1k
         pRB7AEtsr5rfls7dpFUppeEVXU5SbmL8eTpnQCfJP6MUrvsokgJ63/tq0w7sjGZVFQwE
         mWXF6xFwPx0wvIKyh0eYVC5z7fj/1BIIKUa08=
Message-ID: <5a4c581d0810141512u25337c65y4d216816331ed1d9@mail.gmail.com>
Date: Wed, 15 Oct 2008 00:12:32 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: heads-up: 2.6.27-git4 panics on boot and hangs hard in spin_bug
In-Reply-To: <5a4c581d0810140557k37924493x1cad719ac69b205a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0810140557k37924493x1cad719ac69b205a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 2:57 PM, Alessandro Suardi
<alessandro.suardi@gmail.com> wrote:
> I will be posting details in a few hours when I'm back home,
>  boot sequence of my Fedora 9 is about to complete with
>  filesystems mounted, but the BUG doesn't hit the disk;
>  x86 on a Dell Latitude D610.
>
> 2.6.27-git3 works fine.

OK - no need for any details, I looked closer at my stack and
 found out that it was the serial port init bug fixed by Ingo here:

http://lkml.org/lkml/2008/10/14/116

Currently running 2.6.27-git4 plus the above patch.

Thanks,

--alessandro

 "Leave the city, leave the cold / Young people far too old"

   (Anna Ternheim, 'To Be Gone')
