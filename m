Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbZFONWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbZFONWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZFONWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:22:01 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56304 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZFONWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:22:00 -0400
Subject: Re: MCE boot crash in qemu
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090615125200.GD31969@one.firstfloor.org>
References: <19f34abd0906150459v2eb6fd1ak86586bc697c1e69f@mail.gmail.com>
	 <20090615125200.GD31969@one.firstfloor.org>
Date: Mon, 15 Jun 2009 16:22:02 +0300
Message-Id: <1245072122.23207.47.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 14:52 +0200, Andi Kleen wrote:
> x86: mce: Handle banks == 0 case in K7 quirk
> 
> This happens on QEMU which reports MCA capability, but no banks.
> Without this patch there is a buffer overrun and boot ops because the code
> would try to initialize the 0 element of a zero length kmalloc()
> buffer.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

This fixes the bug for me!

Tested-by: Pekka Enberg <penberg@cs.helsinki.fi>

			Pekka

