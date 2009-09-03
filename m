Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbZICCUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbZICCUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 22:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZICCUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 22:20:34 -0400
Received: from tundra.namei.org ([65.99.196.166]:33242 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbZICCUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 22:20:33 -0400
Date: Thu, 3 Sep 2009 12:20:32 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 1/1] IMA: open new file for read
In-Reply-To: <66fbda5f63fbb20bfccf6fd3f8006718f7994ec6.1251901838.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.0909031220190.8302@tundra.namei.org>
References: <66fbda5f63fbb20bfccf6fd3f8006718f7994ec6.1251901838.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009, Mimi Zohar wrote:

> When creating a new file, ima_path_check() assumed the new file
> was being opened for write. Call ima_path_check() with the
> appropriate acc_mode so that the read/write counters are
> incremented correctly.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
