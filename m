Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZG1QXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZG1QXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZG1QXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:23:25 -0400
Received: from outbound-mail-149.bluehost.com ([67.222.38.39]:50493 "HELO
	outbound-mail-149.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752251AbZG1QXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:23:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sM8pLDsGYBSIEc8VY+n7nyAMByXPzwBTo1nHEveEK81qUW1cjhKh5N3z06a1rKu/e9regeLK1oBcVlsr7pSDKfE1ULXBhBrj+qSW5zsBqp1SQfCUm+5h3Ul30WMS9Qc8;
Date: Tue, 28 Jul 2009 09:23:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Paul Rolland <rol@as2917.net>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org, rol@witbe.net
Subject: Re: Linux-2.6.31-rc4 - shut the annoying "failed to acquire
 vblank..."
Message-ID: <20090728092319.52ea57f1@jbarnes-g45>
In-Reply-To: <20090728145359.252ff759@tux.DEF.witbe.net>
References: <20090728091622.50e9933b@tux.DEF.witbe.net>
	<200907281244.13467.elendil@planet.nl>
	<20090728145359.252ff759@tux.DEF.witbe.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 14:53:59 +0200
Paul Rolland <rol@as2917.net> wrote:

> Hi Frans,
> 
> On Tue, 28 Jul 2009 12:44:12 +0200
> Frans Pop <elendil@planet.nl> wrote:
> 
> > > I sent a mail long ago about this message :
> > > tux kernel: [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
> > > counter, -22 showing up more than 10 times per second, but was
> > > told that I had some old userspace apps running... As I was using
> > > an old FC8, I forgot about it.
> > 
> > The message does not only show with old applications, it also shows:
> > - every time I suspend my notebook
> > - every time I start a second X session to log in as a different
> > user
> Well, with the so-called "old apps", it's 20 times per second, as
> long as the app is running, which really makes it painful, because it
> causes all the logs to show off quickly :(
>  
> > I agree that the message is very annoying and would be glad to be
> > rid of it, especially as the only comment from the maintainers so
> > far has been to just ignore it.
> Well, I'd really like some feedback from the maintainer... because if
> no one cares, I agree it should be removed.
> 
> > IMHO, If it is "ignoreable", then it is also "suppressable".
> Seconded, unless someone is using it to try to fix the problem ?

It indicates a userland problem, and yes we shouldn't print that
message.  I've also posted a patch to quiet it a few times, but Dave
hasn't picked it up yet.  Feel free to send it straight to Linus with
my Reviewed-by if you want.

-- 
Jesse Barnes, Intel Open Source Technology Center
