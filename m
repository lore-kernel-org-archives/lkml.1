Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbYDVQor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbYDVQor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbYDVQoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:44:38 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:12132 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbYDVQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:44:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ht9S30oYqcauO4KKrU2zwj5pNgH0Wiq9uBhBNXUuIH696oOzkHTQT4CuQipDHMPhcPKCkFBRFUMHAEot9LLhllawJPer+lfTDpa0QkXWE41qm4jRFdPk7zMp8vkSzComZFu28boWJ4pS3LOypulQjQFHLCReANIDCcjcaHcUgTw=
Message-ID: <b6a2187b0804220944h43f84cb4j3b06ffdee4557f2@mail.gmail.com>
Date: Wed, 23 Apr 2008 00:44:26 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [Broken] PCI: clean up resource alignment management
In-Reply-To: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Ivan,

 I'm having problem loading pccard (Sony PC300 broadband card) with the
 recent git download, and bisected down to this commit.

 commit 884525655d07fdee9245716b998ecdc45cdd8007
 Author: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
 Date:   Sun Mar 30 19:50:14 2008 +0400

    PCI: clean up resource alignment management


 The symptom that I'm seeing is ...

 yenta_cardbus 0000:15:00.0: device not available because of BAR 7
 [100:1ff] collisions
 yenta_cardbus: probe of 0000:15:00.0 failed with error -16

 Reverting the commit solves the problem.

 Let me know if you need me to debug further.

 Thanks,
 Jeff.
