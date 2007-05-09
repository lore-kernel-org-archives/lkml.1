Return-Path: <linux-kernel-owner+w=401wt.eu-S969153AbXEIBsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969153AbXEIBsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968459AbXEIBsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:48:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:29527 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967303AbXEIBsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ib17Hvgcj8jBSR98Zs3LFSE7zNxifLlg+oFmjO2ZY7/rPp8tH61J/v+IFOn/2AG7CcgOM6eD7jcMpqrpEWv8gEnREkDnkx8+M00SN8Pg1/s3oy6DVnYM5xt5LNnba7KU5ooTZ9vvTOprpQ7f/Srh+HqyI9CLua6Gf8OmzpXxtnM=
Message-ID: <a8e1da0705081848n736a8bf0x9675dd4846faa7ba@mail.gmail.com>
Date: Wed, 9 May 2007 01:48:21 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Ken Moffat" <zarniwhoop@ntlworld.com>
Subject: Re: Lockup after logging out of X
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>, "Andi Kleen" <ak@suse.de>
In-Reply-To: <20070508230350.GA911@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070508195142.GA30030@deepthought>
	 <6bffcb0e0705081547t198ed83eg3f4861617216127d@mail.gmail.com>
	 <20070508230350.GA911@deepthought>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Seems I have the same problem. Sometimes whole system is locked,
sometimes keyboard is still active but others dead.

It does not happen till now since I run a silly script on background
to log the kernel messages:
-----------------
#!/bin/sh
while true; do
sleep 3
dmesg >/tmp/dmesg.txt
sync
done
-----------------


My video card is radeon x600 , fglrx driver is not used.
