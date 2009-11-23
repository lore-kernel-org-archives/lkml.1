Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZKWTCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZKWTCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZKWTCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:02:02 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55125 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZKWTCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:02:00 -0500
Subject: Re: [PATCH 1/1] Defer skb allocation for both mergeable buffers
 and big packets in virtio_net
From: Shirley Ma <mashirle@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200911231138.30755.rusty@rustcorp.com.au>
References: <1258697745.7416.20.camel@localhost.localdomain>
	 <4B063509.10006@gmail.com> <1258734101.11049.1.camel@localhost.localdomain>
	 <200911231138.30755.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Mon, 23 Nov 2009 11:01:46 -0800
Message-Id: <1259002906.5022.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rusty,

On Mon, 2009-11-23 at 11:38 +1030, Rusty Russell wrote:
> Overall, the patch looks good.  But it would have been nicer if it
> were
> split into several parts: cleanups, new infrastructure, then the
> actual
> allocation change.

I have split the patch into a set: cleanups, new infrastructure, and
actual allocation change in add buffers: add_recvbuf_big,
add_recvbuf_small, add_recvbuf_mergeage per your suggestion, and also in
recv buffers: recv_big, recv_small, recv_mergeable.

I hope you will agree with it. I am testing the patch-set now, will
submit it soon after finishing all test cases.

Thanks
Shirley

