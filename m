Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbYCTShn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbYCTShn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 14:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbYCTShe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 14:37:34 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:13693 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbYCTShd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 14:37:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fHGCQztSy+qhhSwp5R4QsJePcMWd1o5aVzH6zV+P31XXHJJ3hjhnzLo/LkqXJiFuIzixk1w01fd8zu5U4kwzCujE1G2LTYUTVSwEGQSPtao6XyEtJ6CRnVkaU/EIkWJ0csJryoRgAGcicR2lo39RRA3mL6iQ6Fw0bop7LDoFQ3U=
Subject: Re: [RFC PATCH] kernel: add byteorder macros with alignment fixups
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-netdev <netdev@vger.kernel.org>
In-Reply-To: <20080320182911.GQ10722@ZenIV.linux.org.uk>
References: <1206034454.17059.4.camel@brick>
	 <20080320182911.GQ10722@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 11:37:24 -0700
Message-Id: <1206038244.17059.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 18:29 +0000, Al Viro wrote:
> On Thu, Mar 20, 2008 at 10:34:14AM -0700, Harvey Harrison wrote:
> > A common pattern in the kernel (especially networking) is:
> > 
> > le32_to_cpu(get_unaligned((__le32 *)x));
> > 
> > Repeat for various combinations of le/be and 64/32/16 bit.  Add
> > a variant that operates on possibly unaligned pointers to
> > byteorder/generic.h
> 
> ... and asm/unaligned.h has just acquired fuckloads of places including
> it indirectly.  Not Nice(tm).

Time for linux/unaligned.h?

Do you think the helpers are worth it...wherever they end up?

Harvey

