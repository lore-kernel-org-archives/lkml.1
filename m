Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbYFVHMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbYFVHMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 03:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYFVHM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 03:12:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:57455 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYFVHM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 03:12:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GVwQBR+q93pjkv7f9yo9pIRFoOdG9solvRzbN8NspPOoDLdL5FGuHN9LHhbLM5zRYQ
         m7G2fTBvipRxX6MCfNJRaWShPV6i/tHP3yy0lp/tR2l5Kcfq+2j4W8K2dsN8OKlDI/39
         KzC/HZz6eMR/WfLndgm+/LbBINHDnR11FSQdM=
Message-ID: <b6a2187b0806220012t118d85ffp671abf715c14ea94@mail.gmail.com>
Date: Sun, 22 Jun 2008 15:12:27 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>, ecollins@vmware.com
Subject: Re: Linux 2.6.26-rc7
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       support@vmware.com
In-Reply-To: <alpine.LFD.1.10.0806201626140.3167@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0806201626140.3167@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 7:42 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Another week, another -rc.
> Linus Torvalds (4):
>      Reinstate ZERO_PAGE optimization in 'get_user_pages()' and fix XIP

[89f5b7da2a6bad2e84670422ab8192382a5aeb9f]

This broke vmware 6.0.4.
Jun 22 14:53:03.845: vmx| NOT_IMPLEMENTED
/build/mts/release/bora-93057/bora/vmx/main/vmmonPosix.c:774

Reverting the patch makes vmware runs again. I don't know enough to
fix this, so would be more than test any patches.

Thanks,
Jeff.
