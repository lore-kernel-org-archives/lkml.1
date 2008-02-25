Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbYBYUkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbYBYUkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759556AbYBYUjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:39:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:48681 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759490AbYBYUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:39:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nYoyQvUx+1+3NpSgzFCT9AbedwihFhoBBQafIK8jsAErdECKEIMbpgdeJRaaU5CMp69KHBaEK1lRliXrThOeCRzCiHUzbPlFxzQA/Ta9YQ7aH+2tjhcor7nJqt5Og88dXSrA+15DNpQ4xm9bQEhZaOyGMXUQdL0qnFQ0/EpWjcA=
Message-ID: <8f53421d0802251239s1f8a3c1fleb50f76e2aa00d8c@mail.gmail.com>
Date: Mon, 25 Feb 2008 22:39:42 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org
In-Reply-To: <20080225114611.d91791f6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com>
	 <20080225114611.d91791f6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 9:46 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 25 Feb 2008 21:19:24 +0200 "Michael S. Tsirkin" <m.s.tsirkin@gmail.com> wrote:
>
>  > On my T61p, 2.6.25-rc2 seems to get acpi events from keypresses
>  > such as Fn-F4 and lid open/close, prints them in /var/log/acpid
>  > and reacts accordingly (my acpi scripts suspend on lid close and Fn-F4).
>
>  You mean suspend-to-ram works correctly on your t61p?
>
>  Mine suspends, then five seconds later magically resumes itself and the
>  screen is all black.
>
>

I see the resume problems too, but they do not seem to be acpi-related
(IOW, there are 2 issues). I just finished bisecting and intend to
report shortly.
