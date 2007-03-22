Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbXCVCTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbXCVCTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 22:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbXCVCTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 22:19:08 -0400
Received: from fgwmail9.fujitsu.co.jp ([192.51.44.39]:33421 "EHLO
	fgwmail9.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbXCVCTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 22:19:06 -0400
Date: Thu, 22 Mar 2007 11:17:22 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] FRV: Fix unannotated variable declarations
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070321170659.21330.93301.stgit@warthog.cambridge.redhat.com>
References: <20070321170659.21330.93301.stgit@warthog.cambridge.redhat.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070322111052.6CDE.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Howells <dhowells@redhat.com>
> 
> Fix unannotated variable declarations.  Variables that have allocation section
> annotations (such as __meminitdata) on their definitions must also have them on
> their declarations as not doing so may affect the addressing mode used by the
> compiler and may result in a linker error.

Right. Thanks.

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>


-- 
Yasunori Goto 


