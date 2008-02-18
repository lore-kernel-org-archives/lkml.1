Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbYBRUDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbYBRUDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYBRUDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:03:31 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:41587 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYBRUDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:03:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=aWUoRBZw6Gf+7ppaR7OkzIGLaApMtPivEoJVIYSm3BHA95HttDedhO04ata8N8v+BQTFk59CSlD3hzlGmahTu56RXwEoJIn1dwXms1BXMtkZuD4ofCxKBVV28KQ4kjAZeJol6uD6Qt+I7org7oHA8XhYJmJhIWKJ1SmVm+GLa0E=
Date: Mon, 18 Feb 2008 23:03:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [QUESTION] FRV: linking error?
Message-ID: <20080218200302.GA6741@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

being see over vmlinux.lds for FRV architecture I found the string:

	. = ALIGN(4096);
	.data.page_aligned : { *(.data.idt) }

though the PAGE_SIZE is 16K. Can't figure out why is that...
Do you have a few spare minutes to explain, please?

		- Cyrill -
