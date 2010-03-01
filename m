Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab0CARhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:37:33 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:38147 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750998Ab0CARhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:37:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SgYysuysDqwipOlXg+kqLr09ldEluRxY+96/LtUEZNQS9cGxIaxpggFzGc5OUGOM/cs8oIEMjYNIMLRJVygHoIfIHmu7p7SvuYFit7Gk949mmGXbHWWFTxNTkZmmtJb9;
Date: Mon, 1 Mar 2010 09:38:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCI changes for 2.6.34  - pci rom rom fail list
Message-ID: <20100301093822.34c18e43@jbarnes-piketon>
In-Reply-To: <4B8B0113.1020103@kernel.org>
References: <20100226093957.7b99d09c@jbarnes-piketon>
	<alpine.LFD.2.00.1002281227300.3851@localhost.localdomain>
	<alpine.LFD.2.00.1002281246120.3637@localhost.localdomain>
	<33223F6C-10BD-4671-937D-6D5E4956DD3F@kernel.org>
	<alpine.LFD.2.00.1002281314110.3637@localhost.localdomain>
	<4B8AF121.2060106@kernel.org>
	<4B8B0113.1020103@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Feb 2010 15:49:39 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> please check
> 
> [PATCH] pci: don't reassign to ROM res if it is not going to be
> enabled
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)

Applied this one to my for-linus tree, thanks Yinghai.  I'll send it to
Linus along with another fix tomorrow.

-- 
Jesse Barnes, Intel Open Source Technology Center
