Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbYBKP6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbYBKP6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbYBKP6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:58:34 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:19001 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162AbYBKP6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:58:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LWiqRVJVseCstAGgFSm7Xwiici/K1v5lXMAgvEqtRZvDSOV65SOZuWQWiBPLAkLTAzBIwtLaZSR1a02YwVOmwvM0n7fOrrgWel+WCez8bOZNcblFdH+HjkUE6CJaYAXKwQWf0+3oXgjk6fcylv+Sbdle6DhytlrsSEFcN+mlhxs=
Date: Mon, 11 Feb 2008 10:58:26 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Mike Frysinger <vapier@gentoo.org>,
       Paul Mundt <lethal@users.sourceforge.net>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] SH/Dreamcast - joystick (Control pad)
Message-ID: <20080211105506.ZZRA012@mailhub.coreip.homeip.net>
References: <1202684222.6237.9.camel@localhost.localdomain> <200802101922.29214.vapier@gentoo.org> <15561.85.118.17.158.1202739603.squirrel@newgolddream.dyndns.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15561.85.118.17.158.1202739603.squirrel@newgolddream.dyndns.info>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Mon, Feb 11, 2008 at 02:20:03PM +0000, Adrian McMenamin wrote:
> On Mon, February 11, 2008 12:22 am, Mike Frysinger wrote:
> >
> > no remove function ?  looks like the probe() forces a connect, but there's
> > no
> > remove() to force a disconnect ...
> 
> 
> Removing these devices (or any other plugged directly into the maple
> ports) is a quick way to destroy your Dreamcast: hence they were never
> implemented I guess. But there is no convincing reason for the software
> not doing so, I suppose. I can just put in comments about it.

But what will happen if the driver gets unloaded by user?

-- 
Dmitry
