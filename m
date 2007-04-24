Return-Path: <linux-kernel-owner+w=401wt.eu-S1161224AbXDXNHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161224AbXDXNHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 09:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161732AbXDXNHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 09:07:23 -0400
Received: from mail-a01.ithnet.com ([217.64.83.96]:43094 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1161224AbXDXNHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 09:07:22 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2007 09:07:22 EDT
X-Sender-Authentication: net64
Date: Tue, 24 Apr 2007 14:58:27 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Subject: How to walk through the tasklist ?
Message-Id: <20070424145827.467595a6.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

can anyone give me a short hint how walking through the tasklist in a device
driver can be achieved nowadays. In ancient pre-20 times you could simply:

    read_lock(&tasklist_lock);
    p=current; 
    do {
        if (p->pid==pid) {  
            read_unlock(&tasklist_lock);
            /* found */
        }
        p=p->next_task;
    } while (p!=current);
    read_unlock(&tasklist_lock);

But since tasklist_lock is gone this is not safe any longer. So, what can I do?


-- 
Regards,
Stephan

