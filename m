Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0CBWea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:34:30 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:36181 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0CBWe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:34:29 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alexander Strakh <strakh@ispras.ru>
Subject: Re: BUG mutex_unlock without mutex_lock in drivers/pnp/isapnp/core.c
Date: Tue, 2 Mar 2010 15:34:26 -0700
User-Agent: KMail/1.9.10
Cc: Jaroslav Kysela <perex@perex.cz>, Adam Belay <abelay@mit.edu>,
       linux-kernel@vger.kernel.org
References: <201003011559.40139.strakh@ispras.ru>
In-Reply-To: <201003011559.40139.strakh@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003021534.27001.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 March 2010 08:59:40 am Alexander Strakh wrote:
> 	KERNEL_VERSION: 2.6.33
> 	SUBJECT: mutex_unlock without mutex_lock
> 	DESCRIBE:
> 	In drivers/pnp/isapnp/core.c in function isapnp_get_resources:
> 
> ...
> 4. isapnp_cfg_end in line  886 calls mutex_unlock on &isapnp_cfg_mutex without 
> mutex_lock (it was not locked in function isapnp_cfg_begin because of -
> EINVAL).

Looks like a bug to me.  I'll send a patch.

Bjorn
