Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYHMJYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYHMJYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYHMJYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:24:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:51706 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYHMJYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:24:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZZwPhl0BBUJg1i+5chuVmuN6LUbfr7r095mIL/onjyfspNF1Y/czgD9n0kzzKBaFPk
         LTEMj6PWwNasYTrUcxVnKCEy+qGAdU6fkmq+zmiAl6CF1e1ibqbtADK3Qv54YpvupmS0
         /EJdiD4uTb27t9YXxQAYhae0LU+BIOtWDkSDQ=
Date: Wed, 13 Aug 2008 13:24:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Linux 2.6.27-rc3: waitpid06
Message-ID: <20080813092435.GA10569@martell.zuzino.mipt.ru>
References: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[mostly generic hand-waving]

LTP overnight run resulted in a box which
a) pings
b) reSysRq+Bbootable

And that's all.

SysRq+<the rest> doesn't work (doesn't print anything on console and on
netconsole) nor does ssh to to box. Pressing keys on keyboard doesn't wakeup
console.

Printout stopped at waitpid06 test. This is second time I see this.
First time it was more or less reproducible, there were waitpid06
processes eating all CPU.

