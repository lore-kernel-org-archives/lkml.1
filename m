Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbXI0HLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbXI0HLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbXI0HLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:11:38 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:37068 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbXI0HLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:11:37 -0400
Date: Thu, 27 Sep 2007 09:11:12 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Shreyansh Jain <shreyansh.jain@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: try_module_get code understanding
Message-ID: <20070927071112.GB7966@osiris.boeblingen.de.ibm.com>
References: <loom.20070927T051622-501@post.gmane.org> <20070927061304.GA7966@osiris.boeblingen.de.ibm.com> <loom.20070927T061840-329@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20070927T061840-329@post.gmane.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Then what is return value if my module tries to 'get' a module which does not
> exist (and is a module, not in-built)? . Is it '1' ?
> Or am I imagining a hypothetical scenario which would not exist?

That is not supposed to happen. After a module got unloaded there shouldn't
be any objects around anymore that have an .owner member with an address that
points to the now non-existent module.
