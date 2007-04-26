Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbXDZUdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbXDZUdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbXDZUdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:33:43 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:61037 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbXDZUdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=D91kGW7Fc2lPqwHXRcs5wIN4MoPcV2IcB9mWxp4Ppys3Qzyu1uNu76xITZ0AEca3wjJR5ftE2L90fw7LgrSI1USx0M/rONBT4Z7gMWVa9EIqTx2NmlQ4y4AhR6L4m2LPYdrNi7MJh5DwCxe4mVnw447k3xP8Gm3KMzVMEELJ1fY=
Message-ID: <2fe399760704261333g4dbf79a1p92be761d3680c9d7@mail.gmail.com>
Date: Thu, 26 Apr 2007 13:33:41 -0700
From: "Phy Prabab" <phyprabab@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Non continuous VM address space
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a question, I have a little application and sbrks and then
mmaps to get memory from the system.  Originally, this program worked
fine because I had assumed that my applications address space would be
continuous, each subsequent memory request would "mapped" next to each
other, after all this is the address space for this process.  However,
what I am finding is that the space is discontiguous, I am getting
back addresses not next to each other.  Sometimes the next memory
allocation is several megs above where the previous mapping came from.
 Is this possible?  Or am I not accounting for something?  Yes, I have
intentionally defined malloc, calloc, etc. so they can not be used
under the hood within my code.

BTW, seeing this on 2.6.9 and 2.4.(?) - these are both RH supplied kernels

TIA!
Phy
