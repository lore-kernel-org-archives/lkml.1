Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbZBBSaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbZBBSaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbZBBSaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:30:01 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:36654 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbZBBSaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:30:00 -0500
Message-ID: <49873B99.3070405@nortel.com>
Date: Mon, 02 Feb 2009 12:29:45 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Doug Thompson <norsk5@yahoo.com>, ncunningham-lkml@crca.org.au,
       Pavel Machek <pavel@suse.cz>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: marching through all physical memory in software
References: <715599.77204.qm@web50111.mail.re2.yahoo.com> <m1wscc7fop.fsf@fess.ebiederm.org>
In-Reply-To: <m1wscc7fop.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2009 18:29:51.0511 (UTC) FILETIME=[3C817270:01C98564]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:

> Thinking about it.  We only care about memory the kernel is using so the memory
> maps the BIOS supplies the kernel should be sufficient.  We have weird corner
> cases like ACPI but not handling those in the first pass and getting
> something working should be fine.

Agreed.

The next question is who handles the conversion of the various different 
arch-specific BIOS mappings to a standard format that we can feed to the 
background "scrub" code.  Is this something that belongs in the edac 
memory controller code, or would it live in /arch/foo somewhere?

Chris
