Return-Path: <linux-kernel-owner+w=401wt.eu-S1760495AbZD1O6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495AbZD1O6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758719AbZD1O5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:57:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:54755 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758050AbZD1O5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:57:43 -0400
Date: Tue, 28 Apr 2009 07:52:31 -0700
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH] use dev_set_name(,NULL) to prevent leaking
Message-ID: <20090428145231.GB8352@suse.de>
References: <49E96731.1000501@kernel.org> <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain> <49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de> <ac3eb2510904181300v2593c36dua6c2420828860706@mail.gmail.com> <1240086446.2411.9.camel@poy> <20090418203718.GD30144@elte.hu> <49EA4EB9.2030307@kernel.org> <49F6B1E6.7050008@kernel.org> <49F6B350.9080703@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F6B350.9080703@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 12:42:08AM -0700, Yinghai Lu wrote:
> 
> those about 1/3 dev_set_name() etc.
> 
> wonder if there is better way to do that

I don't see why this is needed, the name will be cleaned up when the
device goes away, automatically, right?

still confused,

greg k-h
