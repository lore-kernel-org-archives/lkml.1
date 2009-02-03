Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbZBCA1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbZBCA1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbZBCA1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:27:10 -0500
Received: from tundra.namei.org ([65.99.196.166]:4399 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbZBCA1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:27:09 -0500
Date: Tue, 3 Feb 2009 11:26:33 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, matthltc@us.ibm.com, zohar@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] TPM: refactoring and integrity
In-Reply-To: <cover.1233592745.git.srajiv@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.1.10.0902031125190.20287@tundra.namei.org>
References: <cover.1233592745.git.srajiv@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009, Rajiv Andrade wrote:

> This patchset contains a refactoring patch and integrity one. The first addresses Matt Helsley and Dave Hansen's comments on replacing the data[] vectors by packed structures making the code easier to read and debug and also consolidates most of the tpm_show_* functions. The second one provides an interface to read and extend PCR values, which is widely used by IMA.
> 
> This version also addresses Matt Helsley's last observation on the timeout_t structure usage to access TPM_CAP_PROP_TIS_DURATION capability, now a new structure is being used, duration_t, whose fields now match exactly as defined in the TPM specification.
> 
> Rajiv Andrade (2):
>   TPM: sysfs functions consolidation
>   TPM: integrity interface
> 
>  drivers/char/tpm/tpm.c |  528 ++++++++++++++++++++++--------------------------
>  drivers/char/tpm/tpm.h |  142 +++++++++++++
>  include/linux/tpm.h    |   35 ++++
>  3 files changed, 423 insertions(+), 282 deletions(-)
>  create mode 100644 include/linux/tpm.h

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

(For some reason, these ended up out of order in my mail folder which 
upset git-am... fixed manually).

-- 
James Morris
<jmorris@namei.org>
