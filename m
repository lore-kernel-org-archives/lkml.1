Return-Path: <linux-kernel-owner+w=401wt.eu-S934214AbXLQLmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbXLQLmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 06:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933819AbXLQLmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 06:42:01 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:52746 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933721AbXLQLmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 06:42:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S6I+LZ4NUzLaoPza18FN6Z7S/g2bFI/mZKvWD4txRUgQ+j5QGFA4ruRS2BIc9Kxj2b8aEDtJP8B+JCABZ1sFHzykusRayQL8ie88qezdUGcNTdAmcrIZkoy0Ss+o1tX/q/95nXBeUouxIkvySugNqMLCf85Ymyq/HdKzvXhKZdk=
Message-ID: <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
Date: Mon, 17 Dec 2007 13:41:58 +0200
From: "Filippos Papadopoulos" <psybases@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: INITIO scsi driver fails to work properly
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20071217031841.f483e5ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <20071217031841.f483e5ac.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 1:18 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 17 Dec 2007 11:39:47 +0200 "Filippos Papadopoulos" <psybases@gmail.com> wrote:
>
> > Hi,
> > I have got an INITIO 9100 UW SCSI Controller with an IBM
> > IC35L036UWD210-0 scsi hard disk on a 32 bit x86 system.
> > Currently i have SUSE 10.1 (Kernel 2.6.16).
> >
> > I tried to install OpenSUSE 10.3 (kernel 2.6.22.5) and the latest
> > OpenSUSE 11.0 Alpha 0  (kernel 2.6.24-rc4) but although the initio
> > driver
> > gets loaded during the installation process, yast reports that no hard
> > disk is found. I believe that this isnt a bug in suse's yast but a
> > problem
> > in the initio scsi driver because i also tried to install Fedora 8
> > (kernel 2.6.23) with the same problem.
> > I have seen the relevant thread "Conflict when loading initio driver"
> > and i suppose that the initio driver isnt fixed yet.
> > I can help testing the new patches in the initio driver if someone is
> > interested.
>
> initio doesn't seem to have a maintainer...
>
> Are you able to identify any earlier kernel which worked OK?
>

I have this PC configuration since 2002. The initio driver worked
perfectly with 2.4 kernel series.
With the release of 2.6 kernel series the driver had been marked as
BROKEN and fixed at 2.6.9
(see at http://www.gossamer-threads.com/lists/linux/kernel/482582?search_string=SCSI%20updates%20for%202.6.9;#482582
  Christoph Hellwig  ->don't mark the initio 9100 driver broken)


> Maybe it's a new device?  If you can get the `lspci -vvxx' output
> for that device we can take a look.
>

No its not a new device.
