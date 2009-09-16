Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbZIPTTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbZIPTTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbZIPTTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:19:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49514 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbZIPTTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:19:33 -0400
Date: Wed, 16 Sep 2009 20:19:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Nelson Elhage <nelhage@ksplice.com>
Subject: Re: [PATCH v2 2/2] arm: Clean up linker script using new linker
	script macros.
Message-ID: <20090916191928.GC16457@n2100.arm.linux.org.uk>
References: <1253119195-19056-1-git-send-email-tabbott@ksplice.com> <1253119195-19056-3-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253119195-19056-3-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 12:39:55PM -0400, Tim Abbott wrote:
> This patch is mostly a straightforward translation. The primary side
> effect to the resulting vmlinux should be to increase the alignment on
> the initramfs to the standard PAGE_SIZE from 32 bytes.

I notice you're not sending this to the ARM lists, which means it's
not getting a full review (eg, by Nico who knows the XIP issues in
here).  Are you sure this is correct for both the XIP and non-XIP
cases?
