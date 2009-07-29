Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbZG2G2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbZG2G2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZG2G2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:28:14 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:52718 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbZG2G2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:28:11 -0400
Date: Wed, 29 Jul 2009 07:26:52 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yoichi Yuasa <yyuasa@linux.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] remove zero-length file in tree
Message-ID: <20090729062652.GA19796@linux-mips.org>
References: <20090729023838.GA15427@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729023838.GA15427@havoc.gtf.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 10:38:38PM -0400, Jeff Garzik wrote:

> Please pull from 'zero-length' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git zero-length
> 
> to receive the following updates:
> 
>  0 files changed, 0 insertions(+), 0 deletions(-)
>  delete mode 100644 drivers/char/vr41xx_giu.c
> 
> Jeff Garzik (1):
>       Remove zero-length file drivers/char/vr41xx_giu.c
> 
> diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
> deleted file mode 100644
> index e69de29..0000000

ACK.  This happened becuase of git's useless interpretation of a
diff(1)-generated patch file.  Junio promised to improve the behaviour.

  Ralf
