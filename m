Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbYEaWfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbYEaWfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 18:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbYEaWe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 18:34:59 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:37725 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754564AbYEaWe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 18:34:58 -0400
Date: Sat, 31 May 2008 23:34:20 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Expose little-endian bitops
Message-ID: <20080531223419.GA30769@solarflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All architectures already have little-endian bitops for use by file-
systems that use little-endian allocation tables.  Since these are
more generally useful - Andrew Morton suggested we use them in the
sfc driver - they should be exposed under consistent names.  The
following patch series does that, using the names from
<asm-generic/bitops/le.h> but without the "generic_" prefix.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
