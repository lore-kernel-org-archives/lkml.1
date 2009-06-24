Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbZFXKrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbZFXKrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZFXKrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:47:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:38108 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZFXKrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:47:24 -0400
Date: Wed, 24 Jun 2009 20:46:50 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Joseph Cihula <joseph.cihula@intel.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: Re: [RFC v5][PATCH 2/4] intel_txt: Intel(R) TXT reboot/halt shutdown
 support
In-Reply-To: <4A4024BE.5090206@intel.com>
Message-ID: <alpine.LRH.2.00.0906242045290.18503@tundra.namei.org>
References: <4A4024BE.5090206@intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Joseph Cihula wrote:

> Support for graceful handling of kernel reboots after an Intel(R) TXT launch.
> 
> Without this patch, attempting to reboot or halt the system will cause the
> TXT hardware to lock memory upon system restart because the secrets-in-memory
> flag that was set on launch was never cleared.  This will in turn cause BIOS
> to execute a TXT Authenticated Code Module (ACM) that will scrub all of memory
> and then unlock it.  Depending on the amount of memory in the system and its type,
> this may take some time.
> 

Does this mean that after a power failure, the system will perform this 
memory scrub on the next boot?  How long does it take per MB on a typical 
system?


-- 
James Morris
<jmorris@namei.org>
