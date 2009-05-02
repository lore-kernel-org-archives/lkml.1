Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZEBSGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZEBSGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 14:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZEBSGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 14:06:06 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:48055 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZEBSGF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 14:06:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=TU4iokOUWeWWm7AyXFkD9E3+X+xhSVY/7nXyE3t+cfHqr/vZrx2YbfUXQNaJ7M8Nmm
         AMG2ppIZsBWiEKVw4DrNbFLBJ6Zdm3W6JMV+/ZKF4jRtMnyxe6eEJHt6Ck08176nMM2b
         4H5Yyg5H0LUVvHmTwTKhBxX+mUKATWq3zGokU=
From: Eric Lacombe <goretux@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [unused symbol] need to use init_mm
Date: Sat, 2 May 2009 20:05:36 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       davej@redhat.com, tglx@linutronix.de
References: <200904301232.05302.goretux@gmail.com> <200904301955.55407.goretux@gmail.com> <20090501155130.GF27831@csn.ul.ie>
In-Reply-To: <20090501155130.GF27831@csn.ul.ie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905022005.37101.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 1 mai 2009 17:51:30 Mel Gorman, vous avez écrit :
> On Thu, Apr 30, 2009 at 07:55:54PM +0200, Eric Lacombe wrote:
> > On Thu, Apr 30, 2009, Ingo Molnar wrote :
> > > * Mel Gorman <mel@csn.ul.ie> wrote:
> > > > On Thu, Apr 30, 2009 at 12:32:04PM +0200, Eric Lacombe wrote:

[...]

> If it's the kernel portion of the address space is what you care about,
> is current->mm->pgd usable?

Not currently, because this one is precisely compared to init_mm.pgd.

[...]

> > > > 4. When do you think the module will be ready for posting?  i.e. is
> > > > this really something destined for mainline or some
> > > > perma-out-of-tree?
> >
> > It is destined for mainline as far as I'm concerned. But it needs to be
> > accepted by the kernel community when it will be ready.
> > (I work for a french public laboratory, so it will be GPL 2 or 3 licensed
> > anyway)
>
> If it really is absolutly necessary that you have init_mm and the
> alternatives really are too ugly, patch 1 of your set becomes a
> re-export of init_mm. The leader of that patch should explain why the
> alternatives to init_mm suck.
>
> You can try posting a patch to export init_mm without an in-tree user but
> I wouldn't bet money on the x86 maintainers picking it up without an
> extremely compelling reason.

Thanks for your comments. I recently thought about an alternative that seems 
to be acceptable.
Nonetheless, I need to modify my security paradigm a little, but this one will 
still be correct. Besides, no ugliness ;)

Best regards,

	Eric

