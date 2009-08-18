Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZHRXru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZHRXru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZHRXrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:47:49 -0400
Received: from ru.mvista.com ([213.79.90.228]:44510 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751514AbZHRXrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:47:48 -0400
Date: Wed, 19 Aug 2009 03:47:49 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Greg KH <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] powerpc/qe&cpm: Implement static inline stubs for
 non-QE/CPM builds
Message-ID: <20090818234749.GA30824@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
 <20090818220418.GD25090@oksana.dev.rtsoft.ru>
 <20090818222747.GB4354@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090818222747.GB4354@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 03:27:47PM -0700, Greg KH wrote:
> On Wed, Aug 19, 2009 at 02:04:18AM +0400, Anton Vorontsov wrote:
> > This is needed to avoid ugly #ifdefs in drivers. Also update fsl_qe_udc
> > driver so that now it doesn't define its own versions that cause build
> > breakage when the generic stubs are used.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> 
> As you're just deleting code, I'll ack that :)
> 
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Hopefully you have tested building this thing...

Yep, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
