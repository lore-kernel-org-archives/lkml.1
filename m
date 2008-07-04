Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYGDIMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYGDIMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 04:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbYGDILf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 04:11:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:45971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbYGDILd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 04:11:33 -0400
Message-ID: <486DDAF8.6050605@kernel.org>
Date: Fri, 04 Jul 2008 17:10:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC PATCH] AHCI: speed up resume
References: <1215074882.3214.15.camel@rzhang-dt.sh.intel.com>	 <486D8F88.9000904@kernel.org> <1215149537.3068.18.camel@rzhang-dt.sh.intel.com>
In-Reply-To: <1215149537.3068.18.camel@rzhang-dt.sh.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Jul 2008 08:11:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Rui wrote:
> From: Zhang Rui <rui.zhang@intel.com>
> 
> During resume, sleep 1 second to wait for the HBA reset
> to finish is a waste of time.
> 
> According to the AHCI 1.2 spec,
> We should poll the HOST_CTL register,
> and return error if the host reset is not
> finished within 1 second.
> 
> Test results show that the HBA reset can be done quickly(in usecs).
> And this patch may save nearly 1 second during resume.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
