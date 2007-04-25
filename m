Return-Path: <linux-kernel-owner+w=401wt.eu-S2992964AbXDYTOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992964AbXDYTOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXDYTOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:14:31 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:49818 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992964AbXDYTOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:14:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Q96wLEAFK6q0QgdJ1gcWU0K/kLhrXegOYRP83we9+5vQOjHTubfQvI3yjN69mTMiJNYQkSZifsOLQWJgMnvK9rTAhGCKLnLQVVFTErYDEXC5X4nMcjXRx43stsNaU+e05XKSnxXZlLvG+myzvFy8OCDIuboyZr0wAG4je/8Sgdc=
Message-ID: <f4e013870704251214s37395ea2i85381313a406c56b@mail.gmail.com>
Date: Wed, 25 Apr 2007 12:14:15 -0700
From: "Mark Hull-Richter" <mhullrich@gmail.com>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: Kernel traces coming back with trash/clutter [SOLVED]
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/07, John Anthony Kazos Jr. <jakj@j-a-k-j.com> wrote:
> > > Perhaps you have something looping that's outputting KERN_DEBUG with a
> > > null message? Or one of your diagnostic printk statements includes
> > > KERN_DEBUG with no actual message?
> > >
> > No, they are all KERN_DEBUG<space>"some string here", almost all with
> > some formatted output as well.  Could I be overloading the printk
> > output buffer, as in possibly too tightly repeated/looped code to be
> > able to output it all?
>
> It is possible, I suppose. Is what you're working on open-source? If so,
> you could send it to me and I could try and reproduce it here and track it
> down. If you want me to, that is. (If you do send, please include a
> ".config".)
>
> Otherwise, I couldn't tell you what it might be. Make sure all your
> messages end with '\n', make sure you're not accidentally using the wrong
> formatting codes and it's backing over previous output with ^H or
> something. You could confirm or rule out the possibility of overflowing
> the printk buffers by writing a dummy module with a tight loop of nothing
> but printk statements with counters to see if you can get it to asplode.
>

It seems that my 'all KERN_DEBUG<space>"some string here"' was off by
one - there was one, the newest, with a comma after the KERN_DEBUG.
Removing it solved the problem.

Many thanks for the assistance.

-- 
Mark Hull-Richter, Linux Kernel Engineer
DATAllegro (www.datallegro.com)
85 Enterprise, Second Floor, Aliso Viejo, CA  92656
949-680-3082 - Office     949-330-7691 - fax
