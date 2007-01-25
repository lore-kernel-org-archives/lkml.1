Return-Path: <linux-kernel-owner+w=401wt.eu-S1030196AbXAYPg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196AbXAYPg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030201AbXAYPg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:36:57 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:24837 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030196AbXAYPg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:36:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VfKuZqECSC1rLEfNf5Z/KPgaHZ7bE+h10AOpy9eRIEbAA2b3hgYfKGqUV1zSvPZXxJzXLgCWhwAhkq7AYnU0P01z/RyW3wDogs1n+HmKoLDuVmi/so4I53CcUdAKw9sIKRnT4iDL6ZUFnWJWXq/LdMCuKn62BnwnhB0piHklTIQ=
Message-ID: <806dafc20701250736yc5c3048u14ec98e9b6b92574@mail.gmail.com>
Date: Thu, 25 Jan 2007 10:36:55 -0500
From: "Christopher \"Monty\" Montgomery" <xiphmont@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Greg KH" <greg@kroah.com>, perex@suse.cz, mclasen@redhat.com,
       jrb@redhat.com, "Lennart Poettering" <lennart@poettering.net>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       fedora-desktop-list@redhat.com
In-Reply-To: <45B8C9A3.6060107@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
	 <20070125042616.GA21813@kroah.com>
	 <806dafc20701250611u9935049ja8f88deb2aac4d40@mail.gmail.com>
	 <45B8C9A3.6060107@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Pierre Ossman <drzeus@drzeus.cx> wrote:
> Christopher "Monty" Montgomery wrote:
> >
> > My machines and the fedora rawhide machines using the 2.6.20-rcX
> > releases look nothing like what you pasted.  If they did, hald would
> > be working...  (I'll note that bugs have also been logged against
> > Pulse and HAL by users having trouble, so it's not just us.)
>
> On my vanilla 2.6.20-rc5, I get the same structure as Greg. Yet hal
> still doesn't pick stuff up as it should.

Interesting to know.  Looking more closely, it looks like machines
here are split between the messed up output I forwarded previously and
the output that is expected.  All of my personal boxes are messed up.

Having looked at HAL earlier, it appeared to have code to parse the
new format but if it desn't work, it doesn't work.  Updating HAL is
relatively easy but I can't test the changes on my own boxes because
they have the messed up /sys/class/sound structure.

Monty
