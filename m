Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab0BOUoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:44:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57279 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467Ab0BOUoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:44:12 -0500
Message-ID: <4B79B202.5090006@zytor.com>
Date: Mon, 15 Feb 2010 12:43:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86: get rid of the insane TIF_ABI_PENDING bit
References: <20100215161752.GA19962@redhat.com>	<4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com>
In-Reply-To: <20100215194123.96D49FC3@magilla.sf.frob.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2010 11:41 AM, Roland McGrath wrote:
> It affects whatever uses is_compat_task(), but I can't see anything
> where that matters except inside some particular syscall or for
> syscall restart after signals.

FWIW, the origin of this is checkin
4d9bc79cd28b779610d9590b3a96a28a0f64a25a (2.6.18-rc1), which somewhat
unhelpfully states "Make sure is_compat_task works early".  It doesn't
specify what the failure is if is_compat_task doesn't work early.  On
the other hand, it sure as heck seems better to set it and not need it
than the other way around.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

