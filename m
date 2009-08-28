Return-Path: <linux-kernel-owner+w=401wt.eu-S1751391AbZH1JNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbZH1JNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 05:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZH1JNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 05:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbZH1JNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 05:13:07 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Michal Schmidt <mschmidt@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xenfb: connect to backend before registering fb
References: <4A96DD03.2080808@goop.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Fri, 28 Aug 2009 11:12:42 +0200
In-Reply-To: <4A96DD03.2080808@goop.org> (Jeremy Fitzhardinge's message of "Thu\, 27 Aug 2009 12\:22\:43 -0700")
Message-ID: <87k50oqp2t.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> As soon as the framebuffer is registered, our methods may be called by the
> kernel. This leads to a crash as xenfb_refresh() gets called before we have
> the irq.
>
> Connect to the backend before registering our framebuffer with the kernel.
>
> [ Fixes bug http://bugzilla.kernel.org/show_bug.cgi?id=14059 ]
>
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Looks good to me.
