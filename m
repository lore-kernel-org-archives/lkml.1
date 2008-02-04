Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbYBDVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbYBDVih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYBDVia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:38:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47164 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752925AbYBDVi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:38:29 -0500
Date: Mon, 4 Feb 2008 13:38:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: legoater@free.fr, linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       xemul@openvz.org
Subject: Re: [PATCH 2/2] extend clone_flags using parent_tidptr argument
Message-Id: <20080204133810.0077ec0d.akpm@linux-foundation.org>
In-Reply-To: <20080204202416.GA26422@sergelap.austin.ibm.com>
References: <47A74AED.1080806@free.fr>
	<20080204202416.GA26422@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 14:24:16 -0600
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting Cedric Le Goater (legoater@free.fr):
> > From: Cedric Le Goater <clg@fr.ibm.com>
> >
> > We have at least 2 patchsets requiring each a new clone flag and there it 
> > is, we've reached the limit, none are left.  
> > This patch uses the CLONE_DETACHED flag (unused) as a marker to extend the 
> 
> Are we pretty sure that there is no legacy software out there which has
> continued to specify CLONE_DETACHED since the kernel ignores it?

Please see -mm's
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch

That patch has been cut back to only recycle CLONE_STOPPED because there
indeed was software out there which is setting CLONE_DETACHED.

See http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-11/msg04293.html

