Return-Path: <linux-kernel-owner+w=401wt.eu-S964967AbXHOXmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967AbXHOXmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964909AbXHOXld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:41:33 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:48456 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867AbXHOXlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:41:31 -0400
Date: Wed, 15 Aug 2007 16:41:31 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: gshan <gshan@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: do_coredump and O_NOFOLLOW
Message-ID: <20070815234130.GA17593@hexapodia.org>
References: <46C290F6.2090309@alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C290F6.2090309@alcatel-lucent.com>
User-Agent: Mutt/1.4.2.2i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 01:36:54PM +0800, gshan wrote:
> I found that O_NOFOLLOW is used for opened core file in Linux 2.6.10. 
> This means the core file couldn't be a symbolic link. However, I want to 
> use symbolic link for core file

I would recommend that you use
# sysctl -w kernel.core_pattern=/tmp/core.%e.%p
instead.  See Documentation/sysctl/kernel.txt for details.

-andy
