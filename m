Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZF1Jki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZF1Jki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 05:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZF1Jka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 05:40:30 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:33433 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZF1Jk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 05:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=YCMghYUPXrNu3VtUmRlkDx/JwKwYO4odOGpVK7CNZH++p7fPYtOWOgQX7s7BaNbWBD
         xOFjMf4rEOPMMSPDv/MQPGvfYXYlZ8gRLSZIiv2zbcg7mIFkV9lnZ2V938AyqQ8hBoc1
         wUrKtbzcfBD8rR2vWPR9R04U3+rQcBMdMVedw=
MIME-Version: 1.0
Date: Sun, 28 Jun 2009 17:40:32 +0800
Message-ID: <b6a2187b0906280240x4bdbaa4as7d0a2b535129d237@mail.gmail.com>
Subject: Unable to reserve port: Resource temporarily unavailable
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, cups-bugs <cups-bugs@easysw.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

" Unable to reserve port: Resource temporarily unavailable" ... this
came CUPS trying to print 2000 jobs, which printer1 is just local
network printer printing to localhost (127.0.0.1).

for((i = 0; i < 2000; i++))
do
date | lpr -Pprinter1
done

Which kernek parameters I can modify to increase network resources? Or
it is CUPS?

Thanks,
Jeff.
