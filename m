Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbYDFHoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbYDFHoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 03:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYDFHo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 03:44:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:43394 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYDFHo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 03:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wACbaX1vDZdjeF/fgKb2lnbxdWcCm7Q1Y6hAF9CqntGt0GARydOo2/gGnt30ykskO8RmYdridf3hTwijBKda8R+3AkmJhUZR4txMzddol6Q7tDkmmiFqs1WgJHLEVTlBeqihy0NfWqcH0z4pFaY8aN3R9KF5KvEWfLBM6F6q01k=
Message-ID: <21d7e9970804060044i25b36802p1859ca25fa532494@mail.gmail.com>
Date: Sun, 6 Apr 2008 17:44:25 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Tilman Schmidt" <tilman@imap.cc>
Subject: Re: [2.6.25-rc6] possible regression: X server dying
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47F1FA3F.3010206@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47E82D68.5070305@imap.cc>
	 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>
	 <47E83D14.8070800@imap.cc>
	 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com>
	 <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>
	 <47F1FA3F.3010206@imap.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2008 at 7:02 PM, Tilman Schmidt <tilman@imap.cc> wrote:
> On Mon, 31 Mar 2008 14:53:29 +1000, Dave Airlie wrote:
>
> > On Tue, Mar 25, 2008 at 10:53 AM, Dave Airlie <airlied@gmail.com> wrote:
> >
> > >
> > > On Tue, Mar 25, 2008 at 9:45 AM, Tilman Schmidt <tilman@imap.cc> wrote:
> > >
> >
>  [...]
>
>
> >
> > >  >  | Backtrace:
> > >  >  | 0: /usr/bin/X(xf86SigHandler+0x81) [0x80e6d81]
> > >  >  | 1: [0xb7fc9400]
> > >  >  | 2:
> /usr/lib/xorg/modules//extensions/libGLcore.so(_swrast_Triangle+0x2d)
> [0xb51ea5dd]
> > >  >  | 3: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb51f1075]
> > >  >  | 4: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb5206f2e]
> > >  >  | 5: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb52080b8]
> > >  >  | 6:
> /usr/lib/xorg/modules//extensions/libGLcore.so(_tnl_run_pipeline+0x153)
> [0xb520cb83]
> > >  >  | 7:
> /usr/lib/xorg/modules//extensions/libGLcore.so(_tnl_draw_prims+0x3f0)
> [0xb51f8340]
> > >  >  | 8:
> /usr/lib/xorg/modules//extensions/libGLcore.so(vbo_exec_vtx_flush+0x1fb)
> [0xb52471eb]
> > >  >  | 9:
> /usr/lib/xorg/modules//extensions/libGLcore.so(vbo_exec_FlushVertices+0x78)
> [0xb52488e8]
> > >  >  | 10:
> /usr/lib/xorg/modules//extensions/libGLcore.so(_mesa_Flush+0x83)
> [0xb5112663]
> > >  >  | 11: /usr/lib/xorg/modules//extensions/libglx.so [0xb7c6a107]
> > >  >  | 12: /usr/lib/xorg/modules//extensions/libglx.so [0xb7c4aa6d]
> > >  >  | 13: /usr/bin/X [0x815809e]
> > >  >  | 14: /usr/bin/X(Dispatch+0x1af) [0x808f68f]
> > >  >  | 15: /usr/bin/X(main+0x47e) [0x807717e]
> > >  >  | 16: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7d5dfe0]
> > >  >  | 17: /usr/bin/X(FontFileCompleteXLFD+0x1e5) [0x8076501]
> > >  >  |
> > >  >  | Fatal server error:
> > >  >  | Caught signal 11.  Server aborting
> > >
> >
> > any look finding what might have caused this?
> >
>
>  Not really. It's obviously triggered by the screensaver. The machine
>  runs SuSE's default: gnome-screensaver with mode = random and a list
>  of 189 candidate screensavers, so I can't tell which one(s) of those
>  actually triggers the problem.
>
>  But perhaps that doesn't matter anyway. I recently collected another
>  X backtrace with kernel 2.6.25-rc7 which looks quite different in
>  the libglx section:
>
>
>  0: /usr/bin/X(xf86SigHandler+0x81) [0x80e6d81]
>  1: [0xb7ef7400]
>  2: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7d8e8]
>  3: /usr/lib/xorg/modules//extensions/libglx.so(DoRender+0xdd) [0xb7b7645d]
>  4: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7657c]
>  5: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7aa6d]
>  6: /usr/bin/X [0x815809e]
>
>  7: /usr/bin/X(Dispatch+0x1af) [0x808f68f]
>  8: /usr/bin/X(main+0x47e) [0x807717e]
>  9: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7c8bfe0]
>  10: /usr/bin/X(FontFileCompleteXLFD+0x1e5) [0x8076501]
>
>  But I know next to nothing about GL, so I'm out of my depth there.
>  I'd welcome any suggestions on how to provoke the crash more
>  regularly so that I could attempt to bisect.

Its one of the GL screensavers, not sure how to narrow it down, use
ldd to figure out which ones are using GL.

I've no idea how the kernel is influencing this.

Dave.
