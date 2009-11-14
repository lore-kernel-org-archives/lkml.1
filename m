Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbZKNAh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbZKNAh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932491AbZKNAh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:37:56 -0500
Received: from smtp.outflux.net ([198.145.64.163]:32803 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484AbZKNAhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:37:55 -0500
Date: Fri, 13 Nov 2009 16:36:52 -0800
From: Kees Cook <kees.cook@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       x86@kernel.org
Subject: Re: [PATCH 0/5] x86: cleanup of NX enabling
Message-ID: <20091114003652.GQ5129@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258154897-6770-1-git-send-email-hpa@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 03:28:17PM -0800, H. Peter Anvin wrote:
> Posting this patch series for review; I intend to commit it to
> tip:x86/mm unless someone objects over the next few days.
> 
> This came about based on Kees' original patch to give better dmesg
> information about the status of NX availability.

FWIW, I tested this stack of patches (in an earlier form) with the
following configurations and confirmed expected behavior:

 -  64-bit, 64-bit noexec=off
 -  32-bit pae with nx bit, x86_32 pae with nx bit noexec=off
 -  32-bit pae without nx bit
 -  32-bit non-pae


Acked-by: Kees Cook <kees.cook@canonical.com>

-- 
Kees Cook
Ubuntu Security Team
