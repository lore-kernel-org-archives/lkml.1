Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZHRWci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZHRWci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZHRWch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:32:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbZHRWch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:32:37 -0400
Date: Tue, 18 Aug 2009 15:27:47 -0700
From: Greg KH <gregkh@suse.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] powerpc/qe&cpm: Implement static inline stubs for
 non-QE/CPM builds
Message-ID: <20090818222747.GB4354@suse.de>
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
 <20090818220418.GD25090@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818220418.GD25090@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 02:04:18AM +0400, Anton Vorontsov wrote:
> This is needed to avoid ugly #ifdefs in drivers. Also update fsl_qe_udc
> driver so that now it doesn't define its own versions that cause build
> breakage when the generic stubs are used.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

As you're just deleting code, I'll ack that :)

	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Hopefully you have tested building this thing...

thanks,

greg k-h
