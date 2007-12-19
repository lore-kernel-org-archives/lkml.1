Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbXLSD7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbXLSD7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 22:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXLSD7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 22:59:33 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:38418 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbXLSD7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 22:59:32 -0500
Message-ID: <4768973C.8020909@davidnewall.com>
Date: Wed, 19 Dec 2007 14:29:56 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Al Viro <viro@ftp.linux.org.uk>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca>
In-Reply-To: <47689608.3030503@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> But.. pity there's no mount flag override for smaller systems,
> where bind mounts might be more useful with link(2) actually working.

I don't see it.  You always can make hard link on the underlying 
filesystem.  If you need to make it on the bound mount, that is, if you 
can't locate the underlying filesystem to make the hard link, you can 
use a symbolic link.
