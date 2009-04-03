Return-Path: <linux-kernel-owner+w=401wt.eu-S1764568AbZDCKkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764568AbZDCKkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763994AbZDCKiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:38:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:27669 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762943AbZDCKiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=cv2v8lWG/fhkevgXZoIu9kf5twSo6hBjWILPp/B3gyJonp/AdfgqW3eFmZUR116R9c
         jLDmWouxz6LKj0IpmNuVPc82+qYhdBJVpU6yBgBTfpAXQBOjSWhTNzQ/i6YV/eEqNMLI
         PX5iOkgaR+VY6NQM2KNewtbKcGWwSJ+z2DIb8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 2/3] ide-cd: cleanup cdrom_decode_status
Date: Fri, 3 Apr 2009 12:41:44 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238655519-10074-2-git-send-email-petkovbb@gmail.com> <200904030108.39927.bzolnier@gmail.com> <20090403045803.GA3732@liondog.tnic>
In-Reply-To: <20090403045803.GA3732@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904031241.44597.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009, Borislav Petkov wrote:
> Hi,
> 
> On Fri, Apr 03, 2009 at 01:08:39AM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 02 April 2009, Borislav Petkov wrote:
> > > - have (almost) equal handling of commands based solely on sense_key
> > 
> > I'm having a VERY hard time trying to review this patch because at
> > the same time that codepaths were merged if()s were replaced by switch()
> > which in turn resulted in change of intendation... on top of that
> > the patch description is very vague about this part of the changes...
> 
> I completely and exactly understand what you are saying :), I thought so
> too when I looked at the diffs yesterday. Well, if it's any consolation, the
> patches've been tested so they seem to work :). Anyway, split version coming
> up...

The split version looks exactly the same except ide_cd_breathe() change
when it comes to the main part.

Did you send the wrong version by any chance?
