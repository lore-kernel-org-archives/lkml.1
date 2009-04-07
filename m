Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbZDGIzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbZDGIzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZDGIy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:54:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:23817 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZDGIyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=SUxE5zfq4yf/b4i6mfj/E6QsoTdtxgOkIVodr6A5X9DWrLZcNnad2nR6TrXr8fk+QJ
         Knu/XZDFRrDwJIKVVtqj1ZQJac83HVedTL/8StBu6TsnWns3ifJA+CG+0ejUsAFLNUGE
         t+scEOLZjjGo6BSqDBiS6EdzV6O0zi1jkHnzQ=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Date: Tue, 7 Apr 2009 10:54:50 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200904011155.20751.a.miskiewicz@gmail.com> <20090403173955.GD6295@elte.hu> <20090403174540.GB27148@sequoia.sous-sol.org>
In-Reply-To: <20090403174540.GB27148@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904071054.51295.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 of April 2009, Chris Wright wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > * Chris Wright <chrisw@sous-sol.org> wrote:
> > > * Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> > > > On Friday 03 of April 2009, Chris Wright wrote:
> > > > > * Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> > > > > > What about 9ea09af3bd3090e8349ca2899ca2011bd94cda85 ?
> > > > > >
> > > > > > stop_machine: introduce stop_machine_create/destroy.
> > > > >
> > > > > That is later fixed in a0e280e0f33f6c859a235fb69a875ed8f3420388.
> > > > >
> > > > > Can you please verify if 2.6.29 works for you?
> > > >
> > > > I think that the guilty part is
> > > > CONFIG_CC_STACKPROTECTOR_ALL=y
> > > > CONFIG_CC_STACKPROTECTOR=y
> > >
> > > Indeed, I think you're right.  In fact...this should fix it:
> >
> > Note that i had to do a manual merge of the patch (it had 3 separate
> > patch corruptions) - the non-damaged version i applied is the one
> > below.
>
> Indeed, I just discovered that ;-)
>
> And, for the record...yes, that fixes it on my laptop.

Also fixes it on mine (just tested recent Linus tree which has this patch 
applied alreday).

Thanks!

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

