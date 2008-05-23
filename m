Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYEWTLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYEWTLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbYEWTLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:11:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:38436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbYEWTLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mOTIrFGVMPW6bmZnKN96gyRTyUv705qpCHRbgmW5a8vT1g6mhDXYihOSjGXvqo2pudKyx5eARCZLu9Uzc1XZMtWsOAbPLyQNbP2dtNwEtUKesUxbGAtaXc2qBjS3dUR5fbvw2ts+xMs8PKyvjgjbj0G8QLdqxgRu7At6cEhWioo=
Message-ID: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>
Date: Fri, 23 May 2008 14:11:43 -0500
From: "Steve French" <smfrench@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: kernel coding style for if ... else which cross #ifdef
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A question splitting "else" and "if" on distinct lines vs. using an
extra line and extra #else came up as I was reviewing a proposed cifs
patch.   Which is the preferred style?

#ifdef CONFIG_SOMETHING
   if (foo)
      something ...
   else
#endif
   if ((mode & S_IWUGO) == 0)

or alternatively

#ifdef CONFIG_SOMETHING
   if (foo)
      something ...
   else if ((mode & S_IWUGO) == 0)
#else
   if ((mode & S_IWUGO) == 0)
#endif


-- 
Thanks,

Steve
