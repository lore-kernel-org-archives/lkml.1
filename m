Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYHSBmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYHSBmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYHSBl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:41:59 -0400
Received: from ozlabs.org ([203.10.76.45]:36777 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbYHSBl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:41:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18602.9348.243840.223801@cargo.ozlabs.ibm.com>
Date: Tue, 19 Aug 2008 11:40:20 +1000
From: Paul Mackerras <paulus@samba.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/23] powerpc: use the new byteorder headers
In-Reply-To: <1219106893.17033.68.camel@brick>
References: <1219106893.17033.68.camel@brick>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison writes:

> -static __inline__ __u16 ld_le16(const volatile __u16 *addr)
...
> -static __inline__ void st_le16(volatile __u16 *addr, const __u16 val)
...
> -static __inline__ __u32 ld_le32(const volatile __u32 *addr)
...
> -static __inline__ void st_le32(volatile __u32 *addr, const __u32 val)

NAK.  Several powerpc-specific drivers use these things that you are
removing, so you just broke those drivers.

Paul.
