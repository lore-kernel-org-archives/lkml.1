Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYAWTBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYAWTBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYAWTBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:01:08 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:54411 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYAWTBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:01:07 -0500
Date: Wed, 23 Jan 2008 20:01:05 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Matt Helsley <matthltc@us.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Al Viro <viro@ftp.linux.org.uk>, David Howells <dhowells@redhat.com>,
       William H Taber <wtaber@us.ibm.com>,
       William Cesar de Oliveira <owilliam@br.ibm.com>,
       Richard Kissel <rkissel@us.ibm.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Fix procfs task exe symlink
In-Reply-To: <1201112977.5443.29.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0801231945530.12676@fbirervta.pbzchgretzou.qr>
References: <1201112977.5443.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 23 2008 10:29, Matt Helsley wrote:
>
>For executables on the stackable MVFS filesystem the current procfs
>methods for implementing a task's exe symlink do not point to the
>correct file and applications relying on the symlink fail (see the
>java example below).

This reminds me of unoionfs - it also had this issue, but IIRC,
it eventually got solved. (Should now display /union/exe rather
than /lowerlevel/exe.) Unionfs developers should know more.
