Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZADKeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZADKeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZADKeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:34:12 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:36941 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZADKeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:34:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=pkc918WdtZEcO5jWoqFBEqXXkWGITO3FV0eDEes0eGQHkc8M9JbLEO7IrqU/YNZBU8
         LF3zhh9TN+4QGdu6AjttX6Lyy9ykuXs9azWxUgCySSE+M6MImO/OTwVem/2Vby+UgwpH
         kfAVebF9EiMXdCJ6LKNUVAILycGkUwM6kAlXA=
Message-ID: <5d5443650901040234y799c4b0en482954db0f4c65c0@mail.gmail.com>
Date: Sun, 4 Jan 2009 16:04:10 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: videobuf-dma-sg.c: build failure on latest Jan 3,2009 tip
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

Build failure on latest tip of linux-2.6 mainline kernel while doing
it for n800 tablet.

  CC      drivers/media/video/videobuf-core.o
  CC      drivers/media/video/videobuf-dma-sg.o
drivers/media/video/videobuf-dma-sg.c: In function 'videobuf_vm_fault':
drivers/media/video/videobuf-dma-sg.c:391: error: implicit declaration
of function 'clear_user_page'
make[3]: *** [drivers/media/video/videobuf-dma-sg.o] Error 1
make[2]: *** [drivers/media/video] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [drivers] Error 2


tip commit id:
commit 7d3b56ba37a95f1f370f50258ed3954c304c524b

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
