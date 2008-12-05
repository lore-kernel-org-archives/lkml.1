Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYLES2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYLES2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYLES2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:28:16 -0500
Received: from kroah.org ([198.145.64.141]:41997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750991AbYLES2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:28:15 -0500
Date: Fri, 5 Dec 2008 10:27:37 -0800
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Jake Edge <jake@lwn.net>, jbarnes@virtuousgeek.org,
       kristen.c.accardi@intel.com, matthew@wil.cx,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [stable] [patch 031/104] PCI: prevent duplicate slot names
Message-ID: <20081205182737.GA2144@kroah.com>
References: <20081203193901.715896543@mini.kroah.org> <20081203195050.GF8950@kroah.com> <20081204221039.GJ31468@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204221039.GJ31468@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 03:10:39PM -0700, Alex Chiang wrote:
> Hi Greg,
> 
> I found a memory leak that I introduced with the below patch.
> 
> I sent the patch to Jesse a few days ago, but he hasn't pushed it
> upstream yet.
> 
> http://article.gmane.org/gmane.linux.kernel.pci/2187/match=stop+leaking
> 
> I did Cc: stable@kernel.org on it, but I'm guessing that since
> it's not upstream yet, you guys never saw it.
> 
> Anyhow, please pick it up for this round of .27-stable, else
> we'll get a memory leak (while trying to work-around the
> duplicate slot name issue).

As much as I hate it, I really need to see the patch in Linus's tree
before I can take it into -stable.

So Jesse, can you please push this to Linus as soon as possible?

Alex, thanks for letting me know about this.

greg k-h
