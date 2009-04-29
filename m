Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbZD2UIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbZD2UIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZD2UIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:08:07 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37888 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZD2UIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:08:07 -0400
X-Greylist: delayed 771 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Apr 2009 16:08:06 EDT
Date: Wed, 29 Apr 2009 12:54:53 -0700
From: Kees Cook <kees@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: CC_STACKPROTECTOR vs CC_STACKPROTECTOR_ALL
Message-ID: <20090429195453.GE8586@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Ubuntu
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What is the rationale for why CC_STACKPROTECTOR_ALL is forced when using
CC_STACKPROTECTOR?  I would have expected _ALL to be a separate option
(as it was in earlier versions), but it seems it is forced on by commit
113c5413cf9051cc50b88befdc42e3402bb92115.

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
