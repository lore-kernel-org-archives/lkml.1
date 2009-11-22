Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZKVECT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZKVECT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 23:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZKVECS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 23:02:18 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52835 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbZKVECS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 23:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rzdm/EcJp4WsmdwdXhTuGzF5hE0mSAn2tNK0z6ml+4zbEMk0WwPk/RFNtQ0WrImnLb
         9AT2eRhLJiZk+aocnKcDoz3JgcWE2ko5iRMpATjWotuMR8+ZyU6xFgIxi90ia5dvUNTr
         7jF4cPaIW4KXf1lDBvwn78e3By/nbwLTp6mmo=
MIME-Version: 1.0
In-Reply-To: <200911220015.30912.rjw@sisk.pl>
References: <200911220015.30912.rjw@sisk.pl>
Date: Sun, 22 Nov 2009 13:55:22 +1000
Message-ID: <21d7e9970911211955i69c12969n3085b6fc2c4a95f9@mail.gmail.com>
Subject: Re: Weird suspend/resume problem on HP nx6325 w/ openSUSE 11.2 w/ 
	-rc8
From: Dave Airlie <airlied@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       DRI <dri-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 9:15 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> I'm not really sure where this should be reported, but here it goes.
>
> After installing openSUSE 11.2 on my testbed nx6325 I noticed that resume
> (from suspend to RAM) stopped working on it.  Apparently, it hanged while
> switching from the console back to X and the box remained completely
> unresponsive after that (it didn't even react to the magic sysrq).  However,
> it used to work just fine with -rc7 and openSUSE 11.1, so I figured the problem
> was related to the new X driver, which is radeon module version 6.12.4 (xorg
> server 1.6.5).
>
> So, I started to investigate and found that after a suspend from a framebuffer
> console, the resume had always worked.  However, when I switched from X to the
> framebuffer console, suspended, resumed and switched back to X, the box hanged
> immediately just like during resume after a suspend from under X.  [There also
> were some problems when switching from X to the framebuffer console and back
> which seemd to be independent of suspend/resume (in short, the screen stays
> black after a switch from the framebuffer console to X and you need to kill X
> to fix this).]

You are using radeonfb on it? or vesafb?

first test is to try without either of those installed.

>From memory though that machines an Xpress 200M which is the the worst
graphics card for use with open drivers and has always caused no-end of pain.

Its also mostly undocumented when it comes to errata and workarounds.

Dave.
