Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbZFVUAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbZFVUAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZFVT75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:59:57 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:55530 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZFVT74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:59:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BSr5ZmBnefH6JqeNfZ7xPYXYvLnV2xfAojjC9XW2rz1hiRslDqoDWFg7JRpa+8wFjn
         q974MkKH5VDLiEG6a2OHurvVhqR9VO0BXAQDomdjcnBGLk5QSmnjDhJRy4OWARk2IJag
         6/tp0jpqH3FxA7uQAdvJvveDNiFCkPNjJ1RmU=
Subject: Re: [PATCH] Add new TAINT_KSPLICE flag for when a Ksplice update
 has been loaded.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Kaseorg <andersk@ksplice.com>,
       Jeffrey B Arnold <jbarnold@ksplice.com>
In-Reply-To: <20090622134655.60b7c44a@dhcp-100-2-144.bos.redhat.com>
References: <alpine.DEB.1.10.0906191422460.29844@vinegar-pot.mit.edu>
	 <20090622134655.60b7c44a@dhcp-100-2-144.bos.redhat.com>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 22:59:53 +0300
Message-Id: <1245700793.8986.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 13:46 -0400, Chuck Ebbert wrote:
> On Fri, 19 Jun 2009 15:57:21 -0400 (EDT)
> Tim Abbott <tabbott@ksplice.com> wrote:
> 
> > Distributions and kerneloops.org have requested that the Ksplice
> > rebootless update system taint the kernel the first time that a
> > Ksplice update is installed, in order to assist with bug triage.
> > 
> > Ksplice uses a new taint flag, TAINT_KSPLICE, displayed as 'K', for
> > this purpose.
> > 
> > We would like to confirm that this use of taint meets with the
> > community's approval and get this taint flag registered in mainline.
> > 
> 
> How about a more generic taint flag that just says some user program has
> patched the running kernel?
Like TAINT_ROOTKIT :-)



> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

