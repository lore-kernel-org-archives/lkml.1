Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZELBfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZELBfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 21:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZELBfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 21:35:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:33544 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbZELBfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 21:35:24 -0400
Date: Tue, 12 May 2009 11:35:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] IMA: use current_cred() instead of current->cred
In-Reply-To: <20090511175909.7719.94816.stgit@dhcp231-142.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0905121134490.4463@tundra.namei.org>
References: <20090511175909.7719.94816.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Eric Paris wrote:

> Proper invocation of the current credentials is to use current_cred() not
> current->cred.  This patches makes IMA use the new method.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

All three applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
