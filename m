Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbYKIKxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbYKIKxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 05:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbYKIKxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 05:53:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:43158 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYKIKxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 05:53:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZjuAnjNAKfZIURT4BX2OXpuIu/ZqMUE1BbNCmNt+vwy6ZvI7VhX7YXD6ZB8odPZuQg
         vyJbEtMq1yy34PsEwI3oNIEpd8AiexPOtIKC6ZHutuXirosVPuhDlcVayDudZyCLTqaZ
         0h4g5cmTdav1EFPOqyGhHpxchMZ6egTpBC6iE=
Date: Sun, 9 Nov 2008 11:52:02 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Arjan van de Ven <arjan@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081109105159.GA5867@joi>
References: <20081104173300.GF6134@ics.muni.cz> <200811090106.04579.rjw@sisk.pl> <20081108205532.7952fec6@infradead.org> <20081109085649.GD4353@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109085649.GD4353@ics.muni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 09:56:49AM +0100, Lukas Hejtmanek wrote:
> On Sat, Nov 08, 2008 at 08:55:32PM -0800, Arjan van de Ven wrote:
> > do you have RAID autoprobing enabled ?
> > raid autoprobing requires that all devices have been discovered,
> > to avoid getting partial RAID arrays and other nasty things...
> > 
> > it's CONFIG_MD_AUTODETECT
> 
> # CONFIG_MD is not set
> 
> I do not have MD at all.
> 
> Moreover, I discovered that I have to hit a keyboard several times during the
> boot to boot up.
> 
> The delay depends on keyboard hit. If I do not touch the keyboard, it waits
> forever.. Looks like something needs an interrupt..

Do you have NO_HZ enabled?
(Cc'ing Thomas)
