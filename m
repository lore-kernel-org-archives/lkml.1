Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYCNARQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYCNARQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYCNAQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:16:57 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34824 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752053AbYCNAQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:16:56 -0400
Date: Thu, 13 Mar 2008 17:16:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
In-Reply-To: <1205400538.3215.148.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>  <20080313014808.f8d25c2a.akpm@linux-foundation.org>
 <1205400538.3215.148.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you recompile the kernel with slub performance statistics and post 
the output of

slabinfo -AD

?


