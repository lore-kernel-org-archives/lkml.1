Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbXFUQzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbXFUQzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbXFUQzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:55:43 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35649 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbXFUQzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:55:41 -0400
Message-ID: <467AACAC.3040202@zytor.com>
Date: Thu, 21 Jun 2007 09:51:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk> <467AA3B4.6090609@zytor.com> <20070621164907.GB28311@sergelap.austin.ibm.com>
In-Reply-To: <20070621164907.GB28311@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> 
> Hmm, or do you actually mean that if i'd done
> 
> 	mount --bind /tmp/a /tmp
> 	mount --bind /tmp/b /tmp
> 	mount --bind /tmp/c /tmp
> 
> that you would want to see information about the first two mounts?
> 

Yes.  Right now, you see all three without any reliable way of knowing
which one is on top.

	-hpa
