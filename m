Return-Path: <linux-kernel-owner+w=401wt.eu-S1764771AbXF1Ppz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764771AbXF1Ppz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbXF1Ppr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:45:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294AbXF1Ppq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:45:46 -0400
Subject: Re: [PATCH 1/2] selinux: don't enable minimum mmap checking by
	default
From: Eric Paris <eparis@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Line.LNX.4.64.0706281139010.13114@localhost.localdomain>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
	 <20070628001221.364438ce.akpm@linux-foundation.org>
	 <20070628012749.caf450f6.akpm@linux-foundation.org>
	 <Line.LNX.4.64.0706281139010.13114@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 28 Jun 2007 11:45:38 -0400
Message-Id: <1183045538.3905.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 11:40 -0400, James Morris wrote:
> Don't enable minimum mmap checking by default in SELinux, as it may break
> existing applications which do not have updated policy.
> 
> We will be able to enable it by default later, once we have code to handle
> new permissions which are not present in the user's policy.
> 
> Signed-off-by: James Morris <jmorris@namei.org>
Acked-by: Eric Paris <eparis@redhat.com>

