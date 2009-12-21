Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZLURWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZLURWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 12:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbZLURWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 12:22:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60367 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZLURW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:22:29 -0500
Message-ID: <4B2FADE2.200@zytor.com>
Date: Mon, 21 Dec 2009 09:18:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ritesh Raj Sarraf <rrs@researchut.com>
CC: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.33-rc1 build failure: copy_from_user() buffer size is not
 provably correct
References: <0io307-9ti.ln1@news.researchut.com> <20091221180537.089C.A69D9226@jp.fujitsu.com> <20091221091330.GA22867@elte.hu> <200912211639.05887.rrs@researchut.com>
In-Reply-To: <200912211639.05887.rrs@researchut.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 03:09 AM, Ritesh Raj Sarraf wrote:
> 
> I have verified the build tree and am building from -rc1 only. The fix you've 
> mentioned above is also part of it.
> 
> debian-build:/tmp/all-yes-config/2.6.33-rc1# cat Makefile |grep EXTRAVERSION
> EXTRAVERSION = -rc1
> 
> Must be a newer bug then.
> 

No, it's the same one, but different gcc.  Sigh.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

