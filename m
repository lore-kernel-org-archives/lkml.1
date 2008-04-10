Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYDJQFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYDJQFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbYDJQEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:04:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:40761 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbYDJQEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AJiltTDsJTeveE67ipsslD/R30WjGvYeL+v1QKy1Wrbo5GdI5+ES0LmDGK9gRqswjxmOXfGPKBOofLjxsJguz3K3AY02ttvpg9M9Hg4eJTTaZFmS8PCewCsLI20yGNeMdatVcQomIWfh8OTdiyytenvaCzXqyau1xzzM0AcwB90=
Message-ID: <dd18b0c30804100904k459d2a6fp33c02672213898e2@mail.gmail.com>
Date: Thu, 10 Apr 2008 16:04:51 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: suspend issue
Cc: "Soeren Sonnenburg" <kernel@nn7.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080410100234.GB11084@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com>
	 <1207490104.4597.36.camel@localhost> <20080406232849.GA789@elf.ucw.cz>
	 <1207736730.4320.1.camel@localhost> <20080410100234.GB11084@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 10:02 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Wed 2008-04-09 12:25:30, Soeren Sonnenburg wrote:
>  > On Mon, 2008-04-07 at 01:28 +0200, Pavel Machek wrote:
>  > > On Sun 2008-04-06 13:55:04, Soeren Sonnenburg wrote:
>  > > > On Sun, 2008-04-06 at 04:03 +0000, Justin Mattock wrote:
>  > > > > Hello; I seem to have discovered something with echo mem > /sys/power/state.
>  > > > > I recompile the kernel and had forgotten to compile fglrx, when
>  > > > > performing a suspend without fglrx I was confronted with the dreaded
>  > > > > blank screen and a reboot. then as a test I compiled fglrx and loaded,
>  > > > > and to my amazement suspend reacted properly again.
>  > > >
>  > > > Yeah, but I it does not even work without X - console only!
>  > > >
>  > > > s2ram -f -p used to work since at least 2.6.20 ... and is now not
>  > > > anymore in 2.6.25-*
>  > >
>  > > Can you do git bisect?
>  >
>  > I just tried, and the problem is that 25-rc1 already fails to suspend -
>  > so I am not sure how I could get more insight into this failure *on
>  > resume*... any ideas?
>
>  Well, 2.6.20 worked, so bisect should be easy, right?
>
>  --
>  (english) http://www.livejournal.com/~pavelmachek
>  (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>

Using git is all new to me, so learning how to do a bisect, is
probably not a bad idea.


-- 
Justin P. Mattock
