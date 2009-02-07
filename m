Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZBGUuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZBGUuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZBGUuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:50:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:61719 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZBGUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:50:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cnLNcLpfeUyxk3hZnz15uEzOQGiB3TCaHauNh43K3COcZruueBHO11su24ApKU9+c2
         ZI1H/o45XtLXQOasDj9XM0taTCQV+QnX6DCXFpvW/S2nwUNmVyFvrp9wwxeLgfcnySqy
         +twT9DVqLBdY9mkyGCfEg+VNtaWK3KVNuxKAA=
Date: Sat, 7 Feb 2009 23:56:07 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: wixor <wixorpeek@gmail.com>
Cc: JosephChan@via.com.tw, linux-kernel@vger.kernel.org
Subject: Re: viafb triggers BUG at mm/vmalloc.c:294 [kernel 2.6.28.3]
Message-ID: <20090207205606.GA3490@x200.localdomain>
References: <c43b2e150902071144j4f01e754y83205ad8d734fd95@mail.gmail.com> <20090207200652.GA3255@x200.localdomain> <c43b2e150902071217id7bfdbaq66dbbd7d5e370c23@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c43b2e150902071217id7bfdbaq66dbbd7d5e370c23@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 09:17:41PM +0100, wixor wrote:
> Done:

Thanks.

Two more things.

1. In via_pci_probe(), there are two ioremap() calls. Insert printks
   before them to determine which of ioremaps is failing (I bet it's the
   first one, still...)

2. Post your .config and dmesg output from the very beginning of boot.
