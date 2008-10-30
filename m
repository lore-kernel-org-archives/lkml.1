Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYJ3OYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYJ3OYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYJ3OYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:24:31 -0400
Received: from lazybastard.de ([212.112.238.170]:50327 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbYJ3OYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:24:31 -0400
Date: Thu, 30 Oct 2008 15:24:20 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: how much license information inside the kernel ?
Message-ID: <20081030142420.GA7157@logfs.org>
References: <488434293@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <488434293@web.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 October 2008 11:54:57 +0100, devzero@web.de wrote:
> 
> i found that there is a LOT of repeating licensing information in the kernel.
> 
> for me, 
> 
> find ./linux-2.6.27 -type f -exec cat {} \; |egrep "free software|GNU General Public License|Free Software Foundation|version 2 of the License|distributed in the hope|WITHOUT ANY WARRANTY|FITNESS FOR A PARTICULAR"
> 
> gives a file sized ~3.5M
> 
> That`s more than 1% of the kernel source.

Scary, isn't it?

One of the problems is that corporate lawyers require the full GPL
preample in any source file.  As a result, a lot of developers inside
companies cannot publish code without it.  Whether that makes any sense
is anyone's guess.  But it doesn't cause much harm either, so better
leave the bloat where it is.

Jörn

-- 
Time? What's that? Time is only worth what you do with it.
-- Theo de Raadt
