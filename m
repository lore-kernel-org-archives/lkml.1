Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbZBFU2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbZBFU2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 15:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZBFU2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 15:28:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58696 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZBFU2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 15:28:21 -0500
Date: Fri, 6 Feb 2009 14:31:43 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/7] integrity: IMA as an integrity service provider
Message-ID: <20090206203143.GA17133@hallyn.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com> <ce9dbebd2ec91ddaf302f5d8146b01311b6b1bd2.1233750615.git.zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce9dbebd2ec91ddaf302f5d8146b01311b6b1bd2.1233750615.git.zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> IMA provides hardware (TPM) based measurement and attestation for
> file measurements. As the Trusted Computing (TPM) model requires,
> IMA measures all files before they are accessed in any way (on the
> integrity_bprm_check, integrity_path_check and integrity_file_mmap
> hooks), and commits the measurements to the TPM. Once added to the
> TPM, measurements can not be removed.
> 
> In addition, IMA maintains a list of these file measurements, which
> can be used to validate the aggregate value stored in the TPM.  The
> TPM can sign these measurements, and thus the system can prove, to
> itself and to a third party, the system's integrity in a way that
> cannot be circumvented by malicious or compromised software.
> 
> - alloc ima_template_entry before calling ima_store_template()
> - log ima_add_boot_aggregate() failure
> - removed unused IMA_TEMPLATE_NAME_LEN
> - replaced hard coded string length with #define name
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>
