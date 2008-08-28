Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYH1TJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYH1TJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYH1TJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:09:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56469 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYH1TJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:09:12 -0400
Message-ID: <48B6F7C5.3020204@kernel.org>
Date: Thu, 28 Aug 2008 12:08:53 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <48B6EC83.1070207@kernel.org> <48B6EE36.5070209@kernel.org>
In-Reply-To: <48B6EE36.5070209@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> 
> Ah.... funky.  If this retry thing is too repulsive, I guess the best
> alternative would be directly accessing caller's memory as Miklos suggested.
> 

Be careful -- there are some serious dragons there in the presence of 
multiple threads.

	-hpa
