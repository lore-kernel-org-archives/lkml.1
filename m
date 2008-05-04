Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYEDSXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYEDSXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYEDSW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:22:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:43067 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbYEDSWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:22:55 -0400
Message-Id: <6C8AB345-2DA0-460D-B7C8-262463247DDE@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: sam@ravnborg.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: How to link a .o with all modules
Date: Sun, 4 May 2008 13:22:38 -0500
Cc: lkml List <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

We have a case in powerpc in which we want to link some library  
routines with all module objects.  The routines are intended for  
handling out-of-line function call register save/restore so having  
them as EXPORT_SYMBOL() is counter productive (we do also need to link  
the same "library" code into the kernel).

Any suggestions on how to handle this?

thanks

- k
