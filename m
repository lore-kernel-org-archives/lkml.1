Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbYGDPic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbYGDPic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 11:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYGDPiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 11:38:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbYGDPiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 11:38:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1215144734.16647.70.camel@brick>
References: <1215144734.16647.70.camel@brick>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] byteorder: fix direct byteswap includes
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Fri, 04 Jul 2008 16:37:43 +0100
Message-ID: <27042.1215185863@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote:

> +#include <asm/byteorder.h>

Please use <linux/byteorder.h> rather than <asm/byteorder.h> when including
stuff from .c files outside the include and arch directories.

And whilst you're at it, Documentation/byteorder.txt is yours for the
creation:-)

David
