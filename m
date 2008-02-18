Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbYBRBW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbYBRBW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYBRBWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:22:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:12633 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYBRBWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:22:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j8sI805kugWZumr9Ab0Y/dlUExx8R1WNC9D3jjAVT/gPRro4Dfx7iBNA+Tve70+gQexQLByD/YAFzX19sMHMa+HwR9GizvdLLHNJnUX1fEMMe98dmxTpKbaDQjoGeeZ0OLkKY4x6kSVoQ80sEeuV6kmm7PlKWWifOtwLpUf+PgY=
Message-ID: <b6a2187b0802171722o3ceab5eaj50f816fbbd65adfb@mail.gmail.com>
Date: Mon, 18 Feb 2008 09:22:18 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Tilman Schmidt" <tilman@imap.cc>
Subject: Re: Linux 2.6.25-rc2 regression: LVM cannot find volume group
Cc: "Jiri Slaby" <jirislaby@gmail.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <47B8D80C.8000408@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	 <47B73616.9050303@imap.cc> <20080216201206.1452cfe7@core>
	 <47B765B1.1030709@gmail.com> <47B8D80C.8000408@imap.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2008 8:57 AM, Tilman Schmidt <tilman@imap.cc> wrote:
> Am 16.02.2008 23:37 schrieb Jiri Slaby:
> > On 02/16/2008 09:12 PM, Alan Cox wrote:
> > Try to upgrade to at least lvm 2.02.29 (I guess this is the first version which
> > understands the new sysfs layout).
> I'll have to investigate how to do that without breaking anything.

I faced the same problem, but resolved with ...

vgscan
vgchange -a y

Also, ensure you set "write_cache_state = 1" in /etc/lvm.conf before
running the above.

Let me know if this helps.


Thanks,
Jeff.
