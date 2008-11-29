Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYK2BFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYK2BFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 20:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYK2BF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 20:05:27 -0500
Received: from kroah.org ([198.145.64.141]:33837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753188AbYK2BF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 20:05:27 -0500
Date: Fri, 28 Nov 2008 17:02:04 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <gregkh@suse.de>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: option: oops on unload (2.6.27.4)
Message-ID: <20081129010204.GA27613@kroah.com>
References: <20081128213254.GB6750@joi> <20081128215021.GA25391@suse.de> <20081128220142.GC6750@joi> <20081128235010.GB27130@suse.de> <20081128165120.4d587db0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128165120.4d587db0@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 04:51:20PM -0800, Arjan van de Ven wrote:
> On Fri, 28 Nov 2008 15:50:10 -0800
> Greg KH <gregkh@suse.de> wrote:
> > > > > i2c_core sr_mod evdev dcdbas cdrom [last unloaded: uhci_hcd]
> 
> ... last unloaded was uhci_hcd ;)

Ah, good point, option wasn't unloaded first.  Yeah, this is a known
issue.  Try unloading option first.

thanks,

greg k-h
