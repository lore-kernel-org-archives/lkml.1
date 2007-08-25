Return-Path: <linux-kernel-owner+w=401wt.eu-S1765984AbXHYBK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765984AbXHYBK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 21:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbXHYBKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 21:10:20 -0400
Received: from ozlabs.org ([203.10.76.45]:38866 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbXHYBKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 21:10:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18127.33141.119362.34178@cargo.ozlabs.ibm.com>
Date: Sat, 25 Aug 2007 11:10:13 +1000
From: Paul Mackerras <paulus@samba.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] fix undefined reference to device_power_up/resume
In-Reply-To: <20070824194201.GA8737@aepfle.de>
References: <20070824194201.GA8737@aepfle.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering writes:

> So change even more places from PM to PM_SLEEP to allow linking.

What config shows these errors?  I presume you need to have CONFIG_PM
but not CONFIG_PM_SLEEP in order to see them?

Paul.
