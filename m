Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbZBYVgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbZBYVgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbZBYVgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:36:10 -0500
Received: from kroah.org ([198.145.64.141]:53251 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754387AbZBYVgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:36:08 -0500
Date: Wed, 25 Feb 2009 13:34:13 -0800
From: Greg KH <greg@kroah.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>, stable@kernel.org,
       Chris Evans <scarybeasts@gmail.com>, linux-kernel@vger.kernel.org,
       Eugene Teo <eugene@redhat.com>, David Howells <dhowells@redhat.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Roland McGrath <roland@redhat.com>, Don Howard <dhoward@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [stable] [PATCH 1/2] copy_process: fix CLONE_PARENT &&
	->exit_signal interaction
Message-ID: <20090225213413.GB26432@kroah.com>
References: <20090225190211.GA7445@redhat.com> <20090225193927.1ED25FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902251156160.3111@localhost.localdomain> <20090225212039.GA11883@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225212039.GA11883@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 10:20:39PM +0100, Oleg Nesterov wrote:
> (can't resist... hopefully now it is clear this should have beeen discussed
>  outside of the closed lists from the very beginning ;)

I don't understand why it wasn't in the first place, holding this back
helped nothing except delay this by a few months :(

