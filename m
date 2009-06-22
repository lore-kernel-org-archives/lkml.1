Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbZFVRso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbZFVRso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZFVRsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:48:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbZFVRsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:48:37 -0400
Date: Mon, 22 Jun 2009 13:46:55 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Kaseorg <andersk@ksplice.com>,
       Jeffrey B Arnold <jbarnold@ksplice.com>
Subject: Re: [PATCH] Add new TAINT_KSPLICE flag for when a Ksplice update
 has been loaded.
Message-ID: <20090622134655.60b7c44a@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <alpine.DEB.1.10.0906191422460.29844@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0906191422460.29844@vinegar-pot.mit.edu>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009 15:57:21 -0400 (EDT)
Tim Abbott <tabbott@ksplice.com> wrote:

> Distributions and kerneloops.org have requested that the Ksplice
> rebootless update system taint the kernel the first time that a
> Ksplice update is installed, in order to assist with bug triage.
> 
> Ksplice uses a new taint flag, TAINT_KSPLICE, displayed as 'K', for
> this purpose.
> 
> We would like to confirm that this use of taint meets with the
> community's approval and get this taint flag registered in mainline.
> 

How about a more generic taint flag that just says some user program has
patched the running kernel?
