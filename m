Return-Path: <linux-kernel-owner+w=401wt.eu-S1760488AbYBIMJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488AbYBIMJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbYBIMG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:06:58 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:27191 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759398AbYBIMG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:06:57 -0500
X-YMail-OSG: VGFBVk8VM1m33QFOVdwogTwhZqTKN66OTJGJGoSnWz8sPhBP5weY9y47wp48MyukmriLbQjK7MWCs1u7dMnBt07iGjMkJKZ6kKOqwsuYP2aekzUkog--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: struct page vs page_link
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mark Tuttle <marklinux@tuttlelabs.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9803672c0802082228h2c3f543ak8c631fcd3a8077ea@mail.gmail.com>
References: <9803672c0802082228h2c3f543ak8c631fcd3a8077ea@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 09 Feb 2008 04:06:17 -0800
Message-Id: <1202558777.1805.220.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-09 at 01:28 -0500, Mark Tuttle wrote:
> Regarding:
> commit 18dabf473e15850c0dbc8ff13ac1e2806d542c15
> 
> This actually breaks the 802.11 subsystem (http://80211.sf.net) which
> relies on the page struct. (ieee80211_crypt_wep.c, line 190) Can
> anyone suggest an alternative kernel function or method? As of 2.6.24,
> the 802.11 subsystem cannot compile.
> 

Greetings Mark,

I have been updating the LIO-Target codebase to 2.6.24 recently, and
posted some information about what I ended up doing for struct
scatterlist->page changing to scatterlist->page_link and
include/linux/scatterlist.h

http://lkml.org/lkml/2008/2/4/111

Hope this helps,

--nab

