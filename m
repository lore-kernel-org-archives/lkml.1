Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbYK2UzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbYK2UzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 15:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYK2UzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 15:55:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:39182 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYK2UzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 15:55:04 -0500
Date: Sat, 29 Nov 2008 12:55:29 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Garrett <mjg@redhat.com>, Jamie Lokier <jamie@shareable.org>,
       =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default
 behaviour
Message-ID: <20081129125529.0198e973@infradead.org>
In-Reply-To: <20081129123220.67fd1e6a.akpm@linux-foundation.org>
References: <20081126195457.GA3541@srcf.ucam.org>
	<20081126195824.GB3541@srcf.ucam.org>
	<492DD035.5020705@oracle.com>
	<20081127150126.GA20941@srcf.ucam.org>
	<20081127150341.GB20941@srcf.ucam.org>
	<20081127170345.GA14991@infradead.org>
	<20081129002419.abfd2504.akpm@linux-foundation.org>
	<20081129130308.GX25548@parisc-linux.org>
	<20081129135742.GC11959@logfs.org>
	<20081129185645.GA20194@shareable.org>
	<20081129190245.GA21502@srcf.ucam.org>
	<20081129123220.67fd1e6a.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 12:32:20 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The standard, usual, expected way of modifying a filesystem's
> behaviour is via mount options.  This is also quite flexible.
> 
> Is there some extraordinary reason why the standard interface is not
> to be used here?


let me ask this:
Has anmyone ever had the desire to change the default of 1 day of
relatime? Ever?
Maybe this code isn't really needed if nobody even thought about
changing it.

Clearly there are two extremes (always and never) for which we have
atime/noatime. I'm not sure we need to have any smarts in the middle
point for the user to change. If this is something people wish to see
tuned better, I would rather spend the code size in trying to get it
autotuning.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
