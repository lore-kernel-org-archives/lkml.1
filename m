Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZA3NOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZA3NOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 08:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZA3NOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 08:14:14 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55708 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZA3NON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 08:14:13 -0500
Subject: Re: [PATCH 3/6] integrity: IMA display
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <alpine.LRH.1.10.0901302013200.31987@tundra.namei.org>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
	 <d92bfa1d386febc0f56c80204203a43d63d42d02.1233262163.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.1.10.0901302013200.31987@tundra.namei.org>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 08:14:11 -0500
Message-Id: <1233321251.3602.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 20:18 +1100, James Morris wrote:
> On Thu, 29 Jan 2009, Mimi Zohar wrote:
> 
> > +int ima_fs_init(void)
> > +{
> > +	ima_dir = securityfs_create_dir("ima", NULL);
> > +	if (!ima_dir || IS_ERR(ima_dir))
> > +		return -1;
> > +
> > +	binary_runtime_measurements =
> > +	    securityfs_create_file("binary_runtime_measurements",
> > +				   S_IRUSR | S_IRGRP, ima_dir, NULL,
> > +				   &ima_measurements_ops);
> > +	if (!binary_runtime_measurements || IS_ERR(binary_runtime_measurements))
> > +		goto out;
> 
> You should not be checking for NULL returns from securityfs_create_file(), 
> because it does not return NULL (the documentation is wrong).
> 
> 
> - James

Thanks!

Mimi

