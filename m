Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZENEzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZENEzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 00:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZENEzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 00:55:38 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:13671 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbZENEzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 00:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=GvNLDN9wEu5wmub6hqOakwtZ5z9cpbJIu2Fl0bVywFd7sS9PMFMxOaD3BzE3MkqB4D
         T9KVf1NQKeU7VGdn3/C2S532fOxR8kKRjSxY02iBJvt2f2Bt+hUZXrgzP4BLZBcxsYFn
         iPyfefo/xuiVYgpSMfO2Knb4hRZYq4Ncje8eo=
MIME-Version: 1.0
Date: Thu, 14 May 2009 10:25:37 +0530
Message-ID: <cee4bbc90905132155q1215bbbdqb246f194fd9ef352@mail.gmail.com>
Subject: SDIO irq handler context
From: Kalpesh Rathod <kalpeshrathod@gmail.com>
To: Kalpesh Rathod <kalpeshrathod@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

SDIO driver irq handler runs in which context?
It always runs in process context ?
or
It runs in either interrupt context or process context? If this is the case,
in_interrupt can be used to distinguish?

Regards,
Kalpesh
