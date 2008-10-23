Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYJWNt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYJWNt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYJWNtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:49:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43829 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYJWNtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:49:19 -0400
Subject: Re: [Devel] Re: [PATCH 08/10] Introduce functions to restart a
	process
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <200810231354.47033.major@openvz.org>
References: <1224285098-573-1-git-send-email-major@openvz.org>
	 <200810221249.55600.major@openvz.org> <48FF20F6.1040505@fr.ibm.com>
	 <200810231354.47033.major@openvz.org>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 06:49:13 -0700
Message-Id: <1224769753.12673.12.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 13:54 +0400, Andrey Mirkin wrote:
> We are putting special structure on stack, which is used at the very end of 
> the whole restart procedure to restore complex states (ptrace is one of such 
> cases). Right now I don't need to use this structure as we have a deal with 
> simple cases, but reservation of 256 bytes on stack is needed for future.

Wow.  So you're saying that, if this patch is accepted, we simply need
to accept that anything being checkpointed will use an extra 256 bytes
of stack?  Seems like something to perhaps put in the changelog rather
than some completely undocumented assembly nugget.

-- Dave

