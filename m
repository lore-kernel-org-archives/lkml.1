Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbZE1Hot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbZE1Hot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZE1Hol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:44:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764AbZE1Hok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:44:40 -0400
Date: Thu, 28 May 2009 00:44:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Ciao <qingtao.cao@windriver.com>
Cc: norsk5@yahoo.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: [v1 PATCH 0/2] EDAC: AMD8111 & AMD8131 Kconfig fixup
Message-Id: <20090528004433.4051e83d.akpm@linux-foundation.org>
In-Reply-To: <1242358006-28339-1-git-send-email-qingtao.cao@windriver.com>
References: <1242358006-28339-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009 11:26:44 +0800 Harry Ciao <qingtao.cao@windriver.com> wrote:

> These are two minor fixups for the AMD8111 and AMD8131 EDAC drivers.
> The direct reference to device.bus_id should be replaced by dev_name().
> 
> Add their missing Makefile entires and introduce machine dependency to 
> their Kconfig options in order to avoid the allmodconfig failure, which
> I have no better idea to avoid although these chips are not specific to
> Maple.

OK, thanks.

Do you think these fixes are safe and desirable for 2.6.30?  (I do).
