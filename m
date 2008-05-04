Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYEDXic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYEDXic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 19:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYEDXiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 19:38:25 -0400
Received: from ozlabs.org ([203.10.76.45]:42152 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbYEDXiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 19:38:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18462.18666.311902.814778@cargo.ozlabs.ibm.com>
Date: Mon, 5 May 2008 09:38:18 +1000
From: Paul Mackerras <paulus@samba.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, sam@ravnborg.org,
       lkml List <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>
Subject: Re: How to link a .o with all modules
In-Reply-To: <481E4655.7040000@zytor.com>
References: <6C8AB345-2DA0-460D-B7C8-262463247DDE@kernel.crashing.org>
	<481E4655.7040000@zytor.com>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:

> Why is having them as an EXPORT_SYMBOL() counterproductive?  It sounds 
> like *exactly* what you need -- and then having the kernel provide the 
> same code to modules, instead of replication...?

It means we would go through a trampoline just to call little things
like __ucmpdi2, which seems a bit unnecessary.

Paul.
