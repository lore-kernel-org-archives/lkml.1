Return-Path: <linux-kernel-owner+w=401wt.eu-S1030239AbXAYP50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030239AbXAYP50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030246AbXAYP50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:57:26 -0500
Received: from nz-out-0506.google.com ([64.233.162.234]:33630 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030239AbXAYP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:57:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HapSV7tQewCltvTxyOsNO6iCfXUK972ACd13qXeMHZvOEeKiQ0ZYOCHSplVxxYuPJA/VgBaL8mBNlVCUvUtRGwGNbcIX2pXeyzev7UfO2KYM8wDXa20Ky+jDgZ5zx5qb29b1hVVsJsQHTVZi0EZgDdvnI1PpN58SPugMp2q6u5g=
Message-ID: <806dafc20701250757n3dcb38b7ma5f8423ab3de9850@mail.gmail.com>
Date: Thu, 25 Jan 2007 10:57:25 -0500
From: "Christopher \"Monty\" Montgomery" <xiphmont@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Greg KH" <greg@kroah.com>, perex@suse.cz, mclasen@redhat.com,
       jrb@redhat.com, "Lennart Poettering" <lennart@poettering.net>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       fedora-desktop-list@redhat.com
In-Reply-To: <45B8CF7E.2040908@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
	 <20070125042616.GA21813@kroah.com>
	 <806dafc20701250611u9935049ja8f88deb2aac4d40@mail.gmail.com>
	 <45B8C9A3.6060107@drzeus.cx>
	 <806dafc20701250736yc5c3048u14ec98e9b6b92574@mail.gmail.com>
	 <45B8CF7E.2040908@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Pierre Ossman <drzeus@drzeus.cx> wrote:

> There is some option about deprecated sysfs stuff. Perhaps this is the
> cause of your twisted tree. It's off here:
>
> # CONFIG_SYSFS_DEPRECATED is not set

It is set.  It is also set in the default config, so plently of people
are running with a broken sysfs tree.

I assume we agree that even if that's set, the tree should not be
outright broken like it is (the compatability mode should actually be
compatable, ie, work, right? :-)  Given that, is my patch correct?
What was there (plugging the old 'dev' arg into the new call's
'parent' makes no sense) is clearly wrong.

And it's clear my pacth is incomplete, as it doesn't correct the
device entries for the other entries.

Monty
