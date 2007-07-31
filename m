Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbXGaMne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbXGaMne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbXGaMn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:43:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33281 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450AbXGaMn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:43:26 -0400
Date: Tue, 31 Jul 2007 18:25:45 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Tejun Heo <htejun@gmail.com>
cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu
Subject: Re: [PATCH 7/7] sysfs: make sysfs_addrm_finish() return void
In-Reply-To: <11858769093479-git-send-email-htejun@gmail.com>
Message-ID: <alpine.LFD.0.999.0707311824420.26032@enigma.security.iitk.ac.in>
References: <11858769093479-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, Tejun Heo wrote:

> With the previous sysfs_add_one() update, there is only one user of
> the return value of sysfs_addrm_finish() and the user can switch to
> testing @sd easily.  Make sysfs_addrm_finish() return void for cleaner
> semantics as suggested by Satyam Sharma.
> 
> This patch doesn't introduce any noticeable behavior change.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Satyam Sharma <satyam.sharma@gmail.com>

Thanks.
