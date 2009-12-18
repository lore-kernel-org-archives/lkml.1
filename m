Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZLRDqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZLRDqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 22:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZLRDqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 22:46:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:55259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbZLRDqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 22:46:50 -0500
Message-ID: <4B2AFBB1.3040609@kernel.org>
Date: Fri, 18 Dec 2009 12:49:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, x86@kernel.org
Subject: Re: 2.6.32 regression: unable to handle kernel paging request
References: <4B269765.1070703@klingt.org> <4B2A2A7D.1050506@klingt.org> <4B2A93F2.3070407@klingt.org>
In-Reply-To: <4B2A93F2.3070407@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/18/2009 05:26 AM, Tim Blechmann wrote:
>> trying to bisect the kernel tree,
>> 405d967dc70002991f8fc35c20e0d3cbc7614f63 seems to be the first bad commit.
>> during bisecting, i recorded several boot logs, which are attached.
> 
> removing module-common.lds from LDFLAGS_MODULE, my machine boots fine
> and without any error messages:

Looks like some necessary part of module image ends up in discarded
sections.  Before the commit, the build process kept those sections so
it worked.  The code has been there for some time now and you're the
first one to report it, so I suppose your .config is a bit different
from more usual ones.  Can you please attach it?

Thanks.

-- 
tejun
