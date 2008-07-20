Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbYGTQni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbYGTQni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbYGTQnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:43:31 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:4734 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYGTQna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:43:30 -0400
Message-ID: <48836B2A.3060704@linuxtv.org>
Date: Sun, 20 Jul 2008 12:43:22 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Trivial fix for drivers/media/Makefile
References: <8763r0a4qy.fsf@denkblock.local>
In-Reply-To: <8763r0a4qy.fsf@denkblock.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> drivers/media/mdtv/ doesn't exist anymore, yet it is still referenced in
> the Makefile.  Due to this glitch, make clean invariably fails.
>
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de
Elias,

Thank you for the effort, but this glitch was just the result of a
problem when Mauro merged the changesets from our mercurial repository
into git.  The Makefile portion of the changeset had been accidentally
dropped.

The problem was in linux-next, and Mauro has already corrected it.


Regards,

Mike
