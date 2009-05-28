Return-Path: <linux-kernel-owner+w=401wt.eu-S1763240AbZE1NpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763240AbZE1NpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758154AbZE1NpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:45:09 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50616 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756184AbZE1NpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:45:08 -0400
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Christoph Hellwig <hch@lst.de>, mingo@elte.hu, rusty@rustcorp.com.au,
       davem@davemloft.net
Subject: Re: [my_cpu_ptr 4/5] sda_icsb_modify_counters() does not need a "cpu" variable
References: <20090527180635.008102701@gentwo.org>
	<20090527180716.456986138@gentwo.org>
From: Olaf Weber <olaf@sgi.com>
Date: Thu, 28 May 2009 15:45:00 +0200
In-Reply-To: <20090527180716.456986138@gentwo.org> (cl@linux-foundation.org's message of "Wed, 27 May 2009 13:47:02 -0400")
Message-ID: <bzyhbz58hpf.fsf@fransum.emea.sgi.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.3 (irix)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cl  writes:

> The xfs_icsb_modify_counters() function no longer needs the cpu variable
> if we use my_cpu_ptr() and we can get rid of get/put_cpu().

> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Olaf Weber <olaf@sgi.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Looks fine to me.

Acked-By: Olaf Weber <olaf@sgi.com>

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com
