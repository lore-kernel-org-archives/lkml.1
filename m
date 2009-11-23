Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZKWIAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZKWIAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZKWIAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:00:40 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:13827 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZKWIAj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Mon, 23 Nov 2009 03:00:39 -0500
Message-Id: <4B0A4F3802000078000215A9@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 23 Nov 2009 08:00:40 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] genksyms: properly consider
	 EXPORT_UNUSED_SYMBOL{,_GPL}()
References: <4B06AD4302000078000211E3@vpn.id2.novell.com>
 <20091122184041.8ed496a7.akpm@linux-foundation.org>
In-Reply-To: <20091122184041.8ed496a7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andrew Morton <akpm@linux-foundation.org> 23.11.09 03:40 >>>
>On Fri, 20 Nov 2009 13:52:51 +0000 "Jan Beulich" <JBeulich@novell.com> wrote:
>
>> Despite being unused these should also get a CRC calculated.
>
>why?

Primarily I view this as a consistency thing. But I also think this is one of
the reasons why __crc_* need to be weak (which I think should be
avoided, and hence we should have the goal to eliminate this so that
failure to calculate a proper CRC for a symbol causes the build to fail).

Jan

