Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYCEEEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYCEEEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 23:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYCEEEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 23:04:04 -0500
Received: from ozlabs.org ([203.10.76.45]:45647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYCEEED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 23:04:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18382.7074.69060.661720@cargo.ozlabs.ibm.com>
Date: Wed, 5 Mar 2008 15:03:46 +1100
From: Paul Mackerras <paulus@samba.org>
To: benh@kernel.crashing.org
Cc: Steven Rostedt <rostedt@goodmis.org>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add strncmp to PowerPC
In-Reply-To: <1204340690.15052.457.camel@pasglop>
References: <1204301097.14759.6.camel@localhost.localdomain>
	<1204340690.15052.457.camel@pasglop>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:

> Do we have any indication that it performs better than the C one ?

I would expect it to, given that the assembler one has two branches in
the per-byte loop compared to 3 in the C version.

Paul.
