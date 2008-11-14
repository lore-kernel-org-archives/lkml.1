Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYKNWT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYKNWT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYKNWTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:19:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129AbYKNWTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:19:19 -0500
Date: Fri, 14 Nov 2008 14:18:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, jmorris@namei.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com
Subject: Re: [PATCH 0/4] integrity
Message-Id: <20081114141813.71a0050a.akpm@linux-foundation.org>
In-Reply-To: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 22:47:10 -0500
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> The Linux Integrity Module (LIM) Framework provides hooks
> for modules to perform collection, appraisal, and storage
> of system integrity measurements. One such module, IMA,
> collects measurements of file data, maintains this list
> in the kernel, and if available, stores (extends) the
> measurements into a hardware TPM. These measurements are
> collected, appraised, and stored before any access
> (read or execute) to the data, so that malicious code or
> data cannot remove or cover up its own measurement, to avoid
> detection. If the measurements are anchored in a TPM, the
> TPM can sign the measurements, for proof of integrity
> to a third party, such as in enterprise client management.
> 
> Integrity measurement is complementary to LSM mandatory
> access control, which can be used to protect the integrity
> of system files. Integrity measurement policies can take
> advantage of LSM labels in deciding what to measure and
> to detect when the protection fails, with hardware strength.

This all looks quite mergeable to me, although I am far from being an
expert on security things.

One thing which I cannot say, and which is quite important: how useful
will all of this be to our users?  Are people asking for it?  Are
people likely to enable and use it?  Are they even likely to understand
it?  ;) Are any large/important customers asking for it?  Are distros
likely to enable and support it?

etc?
