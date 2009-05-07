Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbZEGMqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbZEGMqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZEGMqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:46:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38167 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZEGMqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:46:04 -0400
Date: Thu, 7 May 2009 14:01:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rik van Riel <riel@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, mingo@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH] x86: 46 bit PAE support
Message-ID: <20090507120103.GA1497@ucw.cz>
References: <20090505172856.6820db22@cuia.bos.redhat.com> <4A00ED83.1030700@zytor.com> <4A0180AB.20108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0180AB.20108@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-05-06 08:20:59, Rik van Riel wrote:
> H. Peter Anvin wrote:
>> Rik van Riel wrote:
>>> Testing: booted it on an x86-64 system with 6GB RAM.  Did you really think
>>> I had access to a system with 64TB of RAM? :)
>>
>> No, but it would be good if we could test it under Qemu or KVM with an
>> appropriately set up sparse memory map.
>
> I don't have a system with 1TB either, which is how much space
> the memmap[] would take...

Do we really have 1 byte overhead per 64 bytes of RAM?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
