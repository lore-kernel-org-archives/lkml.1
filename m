Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbYAaI43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbYAaI43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYAaI4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:56:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:17864 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYAaI4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=she5A1eiE1QBerhXjmt3NMAljdxMQMc1dtAeiZJzkhCjkVF8ul1zuK8LYdCsuWvNqjkpwn5Cpxi1F684aYsOKrFFcq+XJnCP9L7fwgy/DqeHo1vVYp8UNmq8+PBZ7dQN32leZjcBsG4YfjEshv9ogegm/gL82LESHZkY0PurdOM=
Message-ID: <38b2ab8a0801310056x3ba59258o92cbb8ecae96d0af@mail.gmail.com>
Date: Thu, 31 Jan 2008 09:56:00 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Francis Moreau" <francis.moro@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Kbuild] How to clean a particular directory ?
In-Reply-To: <20080131084851.GB14160@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0801310038o2906ab68ta8893240576d806d@mail.gmail.com>
	 <20080131084851.GB14160@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 9:48 AM, Paul Mundt <lethal@linux-sh.org> wrote:
>
> On Thu, Jan 31, 2008 at 09:38:10AM +0100, Francis Moreau wrote:
> > I'd like to clean a particular directory in the kernel tree.
> >
> > I tried several things such as:
> >
> > $ make drivers/char clean
> > $ make -f scripts/Makefile.clean obj=drivers/char
> >
> > But it doesn't work.
> >
> > Could anybody give me  a hint ?
>
> make SUBDIRS=drivers/char clean
>
> should do the trick. Kbuild might have a magic incantation for it these
> days, but that's the way it used to work, and still seems to.
>

Thanks Paul, it works fine.

-- 
Francis
