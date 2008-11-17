Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbYKQPZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbYKQPZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYKQPZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:25:09 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:37596 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYKQPZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:25:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Im74GKV/zFkDOUGR32gcA2SxDQCyxNio+DJ4X/C+O+714sK7DIopCnhJxPIgfkSKZ7
         IliAeBSpnSe2qMzytCjS/1VknQRm8NptbM+a4lI62Epw1HkuOvjKY+fYm1E/m5IVGhQw
         tJ5j3ezDLzg2z2P1ByQDwqo1nqsrHYTqDlpRo=
Subject: BUG: MAX_LOCK_DEPTH too low!
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 07:24:37 -0800
Message-Id: <1226935477.3336.5.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running kvm I get an error
about vmalloc not having enough memory
(adding vmalloc=256m resolves the issue);
then during the session I'm seeing:

[  201.020491] BUG: MAX_LOCK_DEPTH too low!
[  201.020498] turning off the locking correctness validator.

other than seeing this in dmesg,
kvm run's really good.

regards;
-- 
Justin P. Mattock <justinmattock@gmail.com>

