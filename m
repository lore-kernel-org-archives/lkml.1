Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZGHLGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZGHLGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZGHLGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:06:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39661 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbZGHLGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:06:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Input: mark serio and i8042 as suspended when hibernating too.
Date: Wed, 8 Jul 2009 13:06:55 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-input@vger.kernel.org, maciej.rutecki@gmail.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <1246760019-4120-1-git-send-email-cascardo@holoscopio.com> <200907070040.43299.rjw@sisk.pl> <20090708065435.GF3309@dtor-d630.eng.vmware.com>
In-Reply-To: <20090708065435.GF3309@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081306.56804.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009, Dmitry Torokhov wrote:
> On Tue, Jul 07, 2009 at 12:40:42AM +0200, Rafael J. Wysocki wrote:
> > On Sunday 05 July 2009, Thadeu Lima de Souza Cascardo wrote:
> > > serio ports are not being restarted any longer because resume operations
> > > after hibernate do nothing, since the device has not been marked as
> > > suspended. This happens because suspend is only considering the SUSPEND
> > > event but not the FREEZE event.
> > > 
> > > Note that this driver has still to migrate to dev_pm_ops, but this fixes
> > > this particular bug now.
> > 
> > Hmm, this looks like a fix for:
> > http://bugzilla.kernel.org/show_bug.cgi?id=13643
> > 
> > Any objections to merging it through the suspend tree?
> > 
> 
> Oops, just applied it to mine before reading your mail... I hope Linus
> will pick my pull request soon so it won't matter thoough.

No problem, I haven't added it to my for-linus branch yet.

Best,
Rafael
