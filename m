Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbYDJG5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbYDJG5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 02:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYDJG5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 02:57:08 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11293 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbYDJG5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 02:57:06 -0400
Date: Thu, 10 Apr 2008 08:57:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Pagano <mpagano@gentoo.org>
Cc: dsd@gentoo.org, iss_storagedev@hp.com,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cciss: error: implicit declaration of function 'sg_init_table'
Message-ID: <20080410065700.GW12774@kernel.dk>
References: <200804091023.40068.mpagano@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804091023.40068.mpagano@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09 2008, Mike Pagano wrote:
> This patch adds the missing include directive <linux/scatterlist.h> to the cciss.c source file.  
> This was discovered by our release team when building the kernel for the Alpha architecture.
> 
> Errors were found as references to functions 'sg_init_table' and 'sg_page' do not exist without the include for Alpha.

Thanks, I'll add it.

-- 
Jens Axboe

