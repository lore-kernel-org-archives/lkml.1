Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbZJNW6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbZJNW6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762019AbZJNW6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:58:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58792 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759714AbZJNW6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:58:05 -0400
Subject: Re: linux-next: tree build failure
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: sfr@canb.auug.org.au, akpm@linux-foundation.org,
       linuxppc-dev@lists.ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
In-Reply-To: <1255115648.2546.71.camel@slab.beaverton.ibm.com>
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
	 <1254267572.15622.1621.camel@slab.beaverton.ibm.com>
	 <4AC318450200007800017355@vpn.id2.novell.com>
	 <1254498517.3839.17.camel@slab.beaverton.ibm.com>
	 <4AC9B5310200007800017EA1@vpn.id2.novell.com>
	 <1255115648.2546.71.camel@slab.beaverton.ibm.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 14 Oct 2009 15:57:06 -0700
Message-Id: <1255561026.29192.0.camel@slab.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 12:14 -0700, Hollis Blanchard wrote:
> Rusty's version of BUILD_BUG_ON() does indeed fix the build break, and
> also exposes the bug in kvmppc_account_exit_stat(). So to recap:
> 
> original: built but didn't work
> Jan's: doesn't build
> Rusty's: builds and works
> 
> Where do you want to go from here?

Jan, what are your thoughts? Your BUILD_BUG_ON patch has broken the
build, and we still need to fix it.

-- 
Hollis Blanchard
IBM Linux Technology Center

