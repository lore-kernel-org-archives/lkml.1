Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbYATFz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbYATFz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 00:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYATFzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 00:55:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50075 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYATFzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 00:55:46 -0500
Message-ID: <4792DF11.7040403@zytor.com>
Date: Sat, 19 Jan 2008 21:41:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> - for mount ID's use IDA (from the IDR library) instead of a 32bit
>   counter, which could overflow

IDAs tend to get reused quickly, which can cause race conditions.  Any 
reason not to just use a 64-bit counter?

	-hpa
