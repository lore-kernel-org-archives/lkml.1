Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZLAG7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZLAG7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZLAG7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:59:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:57192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZLAG7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:59:01 -0500
Message-ID: <4B14BEB6.5090105@kernel.org>
Date: Tue, 01 Dec 2009 15:59:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] percpu: explain quick paths in pcpu_[de]populate_chunk()
References: <20091130091501.4507.28683.sendpatchset@localhost.localdomain> <4B13A7ED.9010905@kernel.org> <alpine.DEB.2.00.0911301258370.18682@router.home> <4B145CE9.1060608@kernel.org> <4B147918.3000503@redhat.com> <4B14A2E6.1070603@kernel.org> <4B14A51E.2090702@kernel.org> <4B14AC35.3020700@redhat.com> <4B14ADE0.3020007@kernel.org> <4B14B936.8080205@redhat.com>
In-Reply-To: <4B14B936.8080205@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 03:35 PM, Cong Wang wrote:
> What do you think about the patch below? Untested.

Oh, yeah, that's prettier.  Just one thing, can you please move rs
initialization right above the pcpu_next_[un]pop() call?  The
input/output parameters for those functions are already pretty
confusing, let's make it at least a bit clearer.

Thanks.

-- 
tejun
