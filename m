Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbXJWCei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbXJWCei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbXJWCea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:34:30 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44374 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbXJWCe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:34:28 -0400
Date: Tue, 23 Oct 2007 08:16:54 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] CFS CGroup: Code cleanup
Message-ID: <20071023024654.GD3324@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <471D4510.9030200@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471D4510.9030200@google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 05:49:20PM -0700, Paul Menage wrote:
> Clean up some CFS CGroup code
> 
> - replace "cont" with "cgrp" in a few places in the CFS cgroup code, 

This change looks good to me. Thanks for doing it.

> - use write_uint rather than write for cpu.shares write function

Minor nit: From pov of making this patch series git bisect safe, shouldn't we 
be registering a write_uint() handler in this patch as well?
 
-- 
Regards,
vatsa
