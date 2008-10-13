Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYJMJCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYJMJCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbYJMJCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:02:25 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:61589 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbYJMJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:02:23 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 23/85] ACPI: Clear WAK_STS on resume
Date: Mon, 13 Oct 2008 11:01:37 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Garrett <mjg@redhat.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>  <32bd813b0324309ab744d70a93bc5d8b82af36ce.1223706853.git.len.brown@intel.com>
In-Reply-To: <32bd813b0324309ab744d70a93bc5d8b82af36ce.1223706853.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810131101.37578.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 11. Oktober 2008 schrieb Len Brown:
> From: Matthew Garrett <mjg59@srcf.ucam.org>
> 
> The leading other brand OS appears to clear the WAK_STS flag on resume.
> When rebooted, certain BIOSes assume that the system is actually
> resuming if it's still set and so fail to reboot correctly. Make sure
> that it's cleared at resume time.
> 
> Comment clarified as suggested by Bob Moore
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>

This patch fixes reboot after suspend on my ASUS P5K.

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

