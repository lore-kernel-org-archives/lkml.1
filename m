Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbXHJIdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbXHJIdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbXHJIcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:32:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761AbXHJIcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:32:51 -0400
Date: Fri, 10 Aug 2007 01:32:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
Message-Id: <20070810013210.1b2f121c.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0708100118r779068i64ffdc11e452be9b@mail.gmail.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<a8e1da0708100118r779068i64ffdc11e452be9b@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 16:18:38 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> Hi,
> 2.6.23-rc2-mm2:
> config with CONFIG_NF_CONNTRACK_AMANDA=y
> boot  oops:
> 
> hand copyed :
> the EIP: helper_hash
> 
> backtrace:
> do_basic_setup
> ...
> nf_conntrack_amanda_init
> error_code
> do_vivide_error
> ...
> 

cc netdev

please send config

presumably nf_ct_helper_hsize is zero

I'd have thought that the same bug would be present in mainline - there's
nothing in git-net.patch.

(hunts around, discovers that there's a net-2.6.24 tree now.  Bah)
