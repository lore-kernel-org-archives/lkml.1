Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbZKKTOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbZKKTOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758489AbZKKTOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:14:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53186 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758401AbZKKTOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:14:19 -0500
Date: Wed, 11 Nov 2009 19:16:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] potential ancient bug (since 1.99.14) at char/pty
Message-ID: <20091111191609.00c14644@lxorguk.ukuu.org.uk>
In-Reply-To: <20091111150103.06cc3489@pedra.chehab.org>
References: <20091111150103.06cc3489@pedra.chehab.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 15:01:03 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Hi Alan/Ts'o,
> 
> There's an open bugzilla at Red Hat for the pty driver that I'm not sure
> what would be the better fix. It tracks to kernel 1.99.14:
> 	http://www.linuxhq.com/kernel/v1.99/13/drivers/char/ChangeLog
> 	http://www.linuxhq.com/kernel/v1.99/13/drivers/char/pty.c

You would need to look at the BSD Unix behaviour and the check SuS v3
specification (which I don't think covers this feature from memory).

I couldn't tell you off hand what the correct behaviour is so you'll have
to do a spot of research
