Return-Path: <linux-kernel-owner+w=401wt.eu-S1764258AbXHANCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764258AbXHANCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761767AbXHANB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:01:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:52120 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760276AbXHANBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:01:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=M4A1RyLwgOwip4xL1HtKNeoGr6HuA1Y8+vdHVTzhFay/4BpDsHrOukzajl3CWuurDhVoo6MRyHiVn5G62J1lCsmjDgOEJUv6KIOhro2gTe9tgGMwOLrqxYtXoAvQc8/AspRksKmCs8sYUi7PdQyuy4X2BVXXmlKOtHfxS3Qy6OE=
Message-ID: <46B0842D.3060703@googlemail.com>
Date: Wed, 01 Aug 2007 15:01:33 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: drivers/scsi/advansys.c compile error ( Re: 2.6.23-rc1-mm2 )
References: <20070731230932.a9459617.akpm@linux-foundation.org>
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Getting this with a randconfig ( http://194.231.229.228/MM/randconfig-auto-10 )

...

drivers/scsi/advansys.c:794:2: warning: #warning this driver is still not properly converted to the DMA API
drivers/scsi/advansys.c: In function 'advansys_board_found':
drivers/scsi/advansys.c:17781: error: implicit declaration of function 'to_pci_dev'
drivers/scsi/advansys.c:17781: warning: pointer/integer type mismatch in conditional expression
drivers/scsi/advansys.c:17788: warning: unused variable 'pci_memory_address'
drivers/scsi/advansys.c:17781: warning: unused variable 'pdev'
make[2]: *** [drivers/scsi/advansys.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make[1]: *** Waiting for unfinished jobs....

...


