Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbYHMIHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbYHMIHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYHMIGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:06:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbYHMIGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:06:54 -0400
Date: Wed, 13 Aug 2008 01:06:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch]fastboot: remove duplicate unpack_to_rootfs()
Message-Id: <20080813010605.b4a55f9b.akpm@linux-foundation.org>
In-Reply-To: <20080813075236.GA8052@elte.hu>
References: <1218607669.3463.9.camel@sli10-desk.sh.intel.com>
	<20080813074503.GB398@elte.hu>
	<20080813075236.GA8052@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 09:52:36 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> no-newline-before-return:
> 
>          kfree(header_buf);
>          return message;
>  }

I accidentally delete those newlines when nobody is looking.  They don't seem
worth the space they consume.

(what do we do with a function which has multiple `return's?)
