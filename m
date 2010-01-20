Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127Ab0ATTiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0ATTiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461Ab0ATTiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:38:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab0ATTiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:38:12 -0500
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Bastien Nocera <hadess@hadess.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
In-Reply-To: <4B575621.9050204@gmail.com>
References: <1264011793.1735.3683.camel@localhost.localdomain>
	 <4B575621.9050204@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 20 Jan 2010 19:37:48 +0000
Message-ID: <1264016268.1735.3915.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 11:14 -0800, Justin P. Mattock wrote:
> On 01/20/10 10:23, Bastien Nocera wrote:
> > As those computers never had any i8042 controllers, and the
> > current lookup code could potentially lock up/hang/wait for
> > timeout for long periods of time.
> >
> > Fixes intermittent hangs on boot on a MacbookAir1,1
<snip>
> glad you submitted this. i.g. been looking at some dmi
> blacklist thing over here(been racking my brain around
> a bit, and seeing your idea simplified it a bit more for me).

Yeah, dmi_check_system() returns the number of matches. I had to look up
the code to see what it did :)

> as for what you have here, do you think individually
> defining each machine is safer, or does it not matter?

For this particular case, it's not necessary, as none of the Apple
machines ever had any i8042 hardware. Or at least that's what Peter
Jones told me, and I have no reasons to doubt him.

Cheers

