Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbXGaK2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbXGaK2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbXGaK2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:28:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:58559 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbXGaK2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=F5SF/1FGLuJ9KkmeFFiV0lgR9acpuwUcSeviYLLOzf4YP4ARDn6M515Ib1segy8WWs1kNwiegJ+hB+05xZMS/HUywTxo71bl/ssEmYBPBAaid26gf7LuIZCgWrH5hKQHhCDCsXoxMrfJuIj53A8VaOU0w4qOvVgAkUTAVton/gk=
Message-ID: <46AF0ECD.9090507@gmail.com>
Date: Tue, 31 Jul 2007 19:28:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu
Subject: Re: [PATCH 2/7] sysfs: Remove first pass at shadow directory support
References: <11858769083285-git-send-email-htejun@gmail.com>
In-Reply-To: <11858769083285-git-send-email-htejun@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> While shadow directories appear to be a good idea, the current scheme
> of controlling their creation and destruction outside of sysfs appears
> to be a locking and maintenance nightmare in the face of sysfs
> directories dynamically coming and going.  Which can now occur for
> directories containing network devices when CONFIG_SYSFS_DEPRECATED is
> not set.
> 
> This patch removes everything from the initial shadow directory support
> that allowed the shadow directory creation to be controlled at a higher
> level.  So except for a few bits of sysfs_rename_dir everything from
> commit b592fcfe7f06c15ec11774b5be7ce0de3aa86e73 is now gone.

"From Eric W. Biederman <ebiederm@xmission.com>" line is missing.  I
thought git scripts would add that automatically.  Sorry about that.

-- 
tejun
