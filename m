Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbYD3REF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbYD3REF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbYD3RDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:03:50 -0400
Received: from organa.snhdns.com ([208.76.82.131]:54019 "EHLO
	organa.snhdns.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbYD3RDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:03:49 -0400
X-Greylist: delayed 2091 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 13:03:49 EDT
Message-ID: <48189FE7.9040208@metricsystems.com>
Date: Wed, 30 Apr 2008 09:35:51 -0700
From: John Clark <jclark@metricsystems.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.13) Gecko/20080313
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with 8250_pnp Module and using ttyS0 as console
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - organa.snhdns.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - metricsystems.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux version... at least as far back as 2.6.19 and upto and including 
the latest
one I've tested, 2.6.25.


When the kernel has been configured to use ttyS0 as the console port, via
modification of the boot command line, 'console=ttyS0,115200', the kernel
ultimately traps with an exception, if the module "8250_pnp.ko" is loaded.

Removing this module eliminates the fault.

Is this a problem or a documented incompatibility?

John Clark.



