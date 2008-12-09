Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYLIWtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYLIWtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbYLIWsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:48:50 -0500
Received: from outbound-mail-17.bluehost.com ([69.89.20.232]:58021 "HELO
	outbound-mail-17.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754714AbYLIWst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:48:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=MkL+H+K24lNkxaHEd1HYYCo/yVgdfhTqDyXHFlntYe7FySssEUeQh1ekDBT7IbsKMn3NQwxRBY5DDYsV4BnilVxi23JVVVOJ14B/EePVcjyjhorBW6lZOtgGhH90KTz8;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [patch 031/104] PCI: prevent duplicate slot names
Date: Tue, 9 Dec 2008 14:41:46 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Jake Edge <jake@lwn.net>, kristen.c.accardi@intel.com, matthew@wil.cx,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
References: <20081203193901.715896543@mini.kroah.org> <20081204221039.GJ31468@ldl.fc.hp.com> <20081205182737.GA2144@kroah.com>
In-Reply-To: <20081205182737.GA2144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091441.47332.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 05, 2008 10:27 am Greg KH wrote:
> On Thu, Dec 04, 2008 at 03:10:39PM -0700, Alex Chiang wrote:
> > Hi Greg,
> >
> > I found a memory leak that I introduced with the below patch.
> >
> > I sent the patch to Jesse a few days ago, but he hasn't pushed it
> > upstream yet.
> >
> > http://article.gmane.org/gmane.linux.kernel.pci/2187/match=stop+leaking
> >
> > I did Cc: stable@kernel.org on it, but I'm guessing that since
> > it's not upstream yet, you guys never saw it.
> >
> > Anyhow, please pick it up for this round of .27-stable, else
> > we'll get a memory leak (while trying to work-around the
> > duplicate slot name issue).
>
> As much as I hate it, I really need to see the patch in Linus's tree
> before I can take it into -stable.
>
> So Jesse, can you please push this to Linus as soon as possible?
>
> Alex, thanks for letting me know about this.

Just sent the pull request, sorry for the delay.

-- 
Jesse Barnes, Intel Open Source Technology Center
