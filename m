Return-Path: <linux-kernel-owner+w=401wt.eu-S2993081AbXCIITh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993081AbXCIITh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993084AbXCIITh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:19:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:61333 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993081AbXCIITg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:19:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZR1Bb/GDUpIwGoT+lsUZZeQpiku7/JrVz9FsZGoZXWhqKUTFr0j/o9r0HgW3OmiBy9/tbtr5LKq5jU1ZkGhPX8qCSPqD4GOU33oAMJxlXsBsaoqne3OKYIq7LrbhDgg2DGABbLM5JTz4PP/lyd/5sj7ZfZLWdC3SDuVUfsb0+9U=
Message-ID: <85e0e3140703090019r7daf5ce4g9269925773374bf7@mail.gmail.com>
Date: Fri, 9 Mar 2007 13:49:34 +0530
From: Niklaus <niklaus@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: more than 65535 outbound connections
In-Reply-To: <85e0e3140703090016h609ecc5t504121a99bcd3e44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <85e0e3140703090016h609ecc5t504121a99bcd3e44@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I could be wrong in the below description or might have misunderstood
many of the concepts , please correct appropriately.

 65535 ports can allowed . So on a  machine namely C you can have max
65535 outbound connections


What i was thinking was to send to another machines A and B from the
same port [X] and then when we get data from it to [X] we can the send
it to the correct application using stateful mapping or storing some
information . The machines A and B are unaware of this mapping from
the C  machine.

Can we increase it by anymeans in the kernel. Does we have patches for the above

 i read on the web that terry lambert has got 1.6 million simultaneous
connection ? how is the way it is done.

http://kerneltrap.org/node/277

Regs
Nik
