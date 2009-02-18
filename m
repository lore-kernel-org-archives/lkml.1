Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbZBRWtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbZBRWtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759609AbZBRWna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:43:30 -0500
Received: from gw.goop.org ([64.81.55.164]:44024 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760837AbZBRWn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:43:28 -0500
Message-ID: <499C8F0C.40202@goop.org>
Date: Wed, 18 Feb 2009 14:43:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, x86@kernel.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       tglx@linutronix.de, rusty@rustcorp.com.au, zach@vmware.com,
       akataria@vmware.com, avi@redhat.com, mtosatti@redhat.com,
       jeremy.fitzhardinge@citrix.com
Subject: Re: [PATCH 0/9] Make lazy mmu update mode pre-empt safe
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com> <20090218143616.ed8f0966.akpm@linux-foundation.org>
In-Reply-To: <20090218143616.ed8f0966.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 18 Feb 2009 14:30:10 -0800
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> This series changes the paravirt-ops lazy update modes in the following ways:
>>     
>
> glumph.  This doesn't look like a 2.6.29 quickfix.
>   

You mean for apply_to_page_range?  No, definitely not, but I don't think 
it has any users wanting to operate on init_mm in 2.6.29.

    J

