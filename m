Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYJDVw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYJDVw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYJDVv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:51:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:59700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbYJDVvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:51:55 -0400
Date: Sat, 4 Oct 2008 14:51:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: add "personality" to process status file
Message-ID: <20081004145149.52c34ee7@infradead.org>
In-Reply-To: <20081002211424.GJ10632@outflux.net>
References: <20081002211424.GJ10632@outflux.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 14:14:24 -0700
Kees Cook <kees.cook@canonical.com> wrote:

> There is no sane way to query the personality flags of arbitrary
> process from userspace.  This adds the flags to the /proc/$pid/status
> file. For example, to detect READ_IMPLIES_EXEC:
> 

.. I'm sure local exploit writers will love this to find out which
processes to attack.
Realistically, this probably shouldn't be in a world-readable file.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
