Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZKBEWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZKBEWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 23:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZKBEWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 23:22:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:35147 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbZKBEWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 23:22:48 -0500
Message-ID: <4AEE5EA2.6010905@kernel.org>
Date: Mon, 02 Nov 2009 05:22:58 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: npiggin@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/1] MM: slqb, fix per_cpu access
References: <1257113578-1584-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1257113578-1584-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jiri Slaby wrote:
> @@ -2770,16 +2770,16 @@ static DEFINE_PER_CPU(struct delayed_work, cache_trim_work);

How about renaming cache_trim_work to slqb_cache_trim_work?  Another
percpu name requirement is global uniqueness (for s390 and alpha
support), so prefixing perpcu variables with subsystem name usually
resolves situations like this better.

Thanks.

-- 
tejun
