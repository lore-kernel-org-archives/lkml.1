Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbYBQTm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbYBQTm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYBQTmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:42:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:22764 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbYBQTmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:42:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=Efpo8OfYbTj+HIxzUbqe7vW6DqryVCdyq/d2OHLxIuI+3p9pzwnsjz+LHdUsS/tSStLiVbEFZTCcTGorR41wMRD5zxeEpCIcqIPgoFYRuGyPJQWEvMh6t9kGm7xzMoqJX9Q5xsNu8tERS4nh1kGt5Rzd9vR5zOiyw6zCnFLk1bM=
Date: Sun, 17 Feb 2008 20:42:14 +0100
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-sh@vger.kernel.org, Paul Mundt <lethal@users.sourceforge.net>,
       Magnus Damm <magnus.damm@gmail.com>, matsu@igel.co.jp,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current git very broken on the Dreamcast
Message-Id: <20080217204214.de9c4612.Kristoffer.ericson@gmail.com>
In-Reply-To: <1203191988.6737.11.camel@localhost.localdomain>
References: <1203187080.6737.3.camel@localhost.localdomain>
	<1203191304.6737.5.camel@localhost.localdomain>
	<1203191988.6737.11.camel@localhost.localdomain>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 19:59:48 +0000
Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:

> 
> On Sat, 2008-02-16 at 19:48 +0000, Adrian McMenamin wrote:
> > On Sat, 2008-02-16 at 18:38 +0000, Adrian McMenamin wrote:
> > > Will seek to bisect this, but I have just updated my sources to the
> > > latest git and it is not booting at all on the Dreamcast.
> > > 
> 
> > adrian@bossclass:~/gdrom-dev$ git bisect good
> > e036eaa681a17f71b64f6d9040fe605555623919 is first bad commit
> > commit e036eaa681a17f71b64f6d9040fe605555623919
> > Author: Magnus Damm <magnus.damm@gmail.com>
> > Date:   Thu Feb 14 13:52:43 2008 +0900
> > 
> 
> Reverting this commit *will* let my Dreamcast boot - can it be rolled
> back pending further testing for a patch please?

Since you know the cause I'm sure Magnus will have some ideas about why it broke, so just hold on for him to reply.

> 
> Adrian
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
