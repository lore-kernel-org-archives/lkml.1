Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954Ab0AVRZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0AVRZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266Ab0AVRZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:25:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50126 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab0AVRZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:25:44 -0500
Message-ID: <4B59DF4C.7040608@zytor.com>
Date: Fri, 22 Jan 2010 09:24:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, andreas.herrmann3@amd.com,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH -v3 0/5] x86, cacheinfo, amd: L3 Cache Index Disable fixes
References: <1264172467-25155-1-git-send-email-bp@amd64.org>
In-Reply-To: <1264172467-25155-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2010 07:01 AM, Borislav Petkov wrote:
> these are a bunch of fixes which correct the disabling of L3 cache
> indexes. This is needed, for example, in the case when excessive
> correctable L3 error rates are observed. In a later step, this
> functionality will be connected to the mcheck mechanism and used to
> evaluate occurring L3 tag and data array errors and then disable the
> respective failing L3 cache regions in order to defer system failure
> before a sysop can intervene.
> 
> Those patches are also good -stable candidates.

Hmmm... I'm not sure I see a strong justification for a late -rc push
into Linus/stable push for for these... I think you would have to
explicitly make the case if you want them to be considered as such.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

