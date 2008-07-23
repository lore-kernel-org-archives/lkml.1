Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYGWVnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYGWVnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbYGWVnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:43:23 -0400
Received: from 8bytes.org ([88.198.83.132]:34803 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782AbYGWVnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:43:22 -0400
Date: Wed, 23 Jul 2008 23:43:20 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: improve double fault handling
Message-ID: <20080723214320.GC13662@8bytes.org>
References: <4880A912.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4880A912.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 01:30:42PM +0100, Jan Beulich wrote:
> Make the double fault handler use CPU-specific stacks. Add some
> abstraction to simplify future change of other exception handlers to go
> through task gates.

What is the benefit of exception handlers going through task gates?
Hardware task switches are not very well supported in virtualization
(e.g. its has issues in KVM and is also not in Xen for a long time).

Joerg

