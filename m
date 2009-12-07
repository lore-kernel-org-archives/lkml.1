Return-Path: <linux-kernel-owner+w=401wt.eu-S964937AbZLGSGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbZLGSGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964868AbZLGSGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:06:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964862AbZLGSGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:06:47 -0500
Date: Mon, 7 Dec 2009 09:57:43 -0800
From: Greg KH <gregkh@suse.de>
To: Emese Revfy <re.emese@gmail.com>
Cc: lenb@kernel.org, astarikovskiy@suse.de, mchehab@infradead.org,
       linville@tuxdriver.com, miklos@szeredi.hu, davem@davemloft.net,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
       avi@redhat.com, mtosatti@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 11/31] Constify struct file_operations for 2.6.32 v1
Message-ID: <20091207175743.GA25930@suse.de>
References: <4B198C43.50205@gmail.com>
 <4B19A333.5080103@gmail.com>
 <20091205000942.GA8224@suse.de>
 <4B19CA6F.4090700@gmail.com>
 <20091205041507.GA24885@suse.de>
 <4B1B0D40.3040209@gmail.com>
 <20091206172526.GA17480@suse.de>
 <4B1C500E.5040406@gmail.com>
 <20091207151156.GA27574@suse.de>
 <4B1D3CCB.5000607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D3CCB.5000607@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 06:35:07PM +0100, Emese Revfy wrote:
> >> From: Emese Revfy <re.emese@gmail.com>
> >>
> >> Constify struct file_operations with some exceptions.
> > 
> > Now please break this patch (and your others) out into "one subsystem at
> > a time" type thing so it will have a chance at being applied.
> 
> Shall i split them up per subsystem and structure type or
> only per subsystem (that is, include all affected structures
> in the given subsystem)?

Both.

thanks,

greg k-h
