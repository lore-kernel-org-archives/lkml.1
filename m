Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZIKBnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZIKBnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZIKBnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:43:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34750 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZIKBnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:43:40 -0400
Message-ID: <4AA9AB00.9030607@zytor.com>
Date: Thu, 10 Sep 2009 18:42:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Daney <ddaney@caviumnetworks.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH 02/10] x86: Convert BUG() to use unreachable()
References: <4AA991C1.1050800@caviumnetworks.com>	<1252627011-2933-2-git-send-email-ddaney@caviumnetworks.com>	<4AA9A031.5000602@zytor.com>	<alpine.LFD.2.01.0909101806110.3654@localhost.localdomain> <20090911013743.1CF13AEF@magilla.sf.frob.com>
In-Reply-To: <20090911013743.1CF13AEF@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2009 06:37 PM, Roland McGrath wrote:
>> There are other cases where that kind of config-time testing could be 
>> useful, and we could avoid doing various gcc checks dynamically from 
>> within 'make' (along with checking for known-buggy versions etc).
> 
> I quite agree that this would be an improvement for many sorts of compiler
> feature (and other tool detail) conditionalization.

The nicest, of course, would be if gcc exported its internal support,
similar to the way it nowadays export macros for the various internal
data types.

	-hpa
