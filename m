Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbYLCVKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbYLCVKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYLCVKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:10:32 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47744 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbYLCVKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:10:31 -0500
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 13:10:22 -0800
Message-Id: <1228338622.26913.37.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 16:47 -0500, Mimi Zohar wrote:
> IMA provides hardware (TPM) based measurement and attestation for both
> files and other types of template measurements. As the Trusted Computing
> (TPM) model requires, IMA measures all files before they are accessed
> in any way (on the bprm_check_integrity, path_check_integrity, and
> file_mmap hooks), and commits the measurements to the TPM.  In addition,
> IMA maintains a list of these hash values, which can be used to validate
> the aggregate PCR value.  The TPM can sign these measurements, and thus
> the system can prove to itself and to a third party these measurements
> in a way that cannot be circumvented by malicious or compromised software.

I think this needs a bit of a plain-text explanation, sans acronyms.
Perhaps a real-world example with files like /etc/passwd or /bin/sh
would help me understand it better.	

I'm still trying to wrap my head around the whole "invalidate something
when there are both readers and writers around" situation.  How does
that fit into the description above?  Does that tie into the guarantee
that "IMA measures all files before they are accessed in any way"?

-- Dave

