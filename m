Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbYDLDTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbYDLDTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 23:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbYDLDTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 23:19:35 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:10674 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbYDLDTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 23:19:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rmQtf8OLyBs5QBjicUuIm60n7w4ZRsyErvyRBxIqeYH7rTV3t+4iLwSiRxMUUk4xMs2m81RhiKvd2Fv/RttctWVIlnb1noYi5xxC0zIfuO1r//Bws5tqB3AxlzsZSZbGxOcthkYpgNGpMj+XBXnUDWCErhNUc0XvMRz/jp94Ibk=
Message-ID: <170fa0d20804112019h73928c99paadcc363539fea9c@mail.gmail.com>
Date: Fri, 11 Apr 2008 23:19:33 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Subject: Re: Western Digital GreenPower drives and Linux
Cc: devzero@web.de, lkml@metanurb.dk, pernegger@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <200804112200.28854.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <234148243@web.de> <200804112200.28854.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 5:00 PM, Tvrtko A. Ursulin <tvrtko@ursulin.net> wrote:
>
>  > >I got back from WD's tech support and received a DOS utility which can
>  > > control this drive feature, apparently using vendor specific commands.
>  > > With it head unload timer can be disabled or set to a period between
>  > > 100ms and 25.5s.
>
>  Followup with some good news.
>
>  Head unload timer settings seems to be persistent across powering off. Having
>  set it to a maximum value of 25.5 seconds my disk is now behaving much more
>  reasonable.
>
>  To actually do it I used FreeDOS floppy image burnt on a CD-RW as a bootable
>  image plus wdidle3.exe in the filesystem itself.
>
>  BTW, WD's tech support has gone silent so chances for an easier solution are
>  not so great.

Any chance you could make your iso available for the freedos w/
wdidle3.exe bootable cd?

I can't track down wdidle3.exe on wdc.com; they have "Data Lifeguard"
and such but I have no idea if the wdidle3.exe is buried in those
downloads.

thanks,
Mike
