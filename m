Return-Path: <linux-kernel-owner+w=401wt.eu-S935063AbXHHC6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063AbXHHC6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 22:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759134AbXHHC57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 22:57:59 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:14675 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459AbXHHC55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 22:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CS64a5Z/iN3o7ijzokko3KtvK/ydcKuY/rIZ9RCiqPGEqoeikmiILk2d4MBcISspoUgvVaA8nbkAzNmnptdEw9fkqj2udB8HVhoOsLlDZbLY7O4mXNFho4iz2kXxnb9SBO4KHGob5awpCFLLgD6g6zwi2haYjb0LV+x9kKCmVbg=
Message-ID: <46B930ED.6040607@gmail.com>
Date: Wed, 08 Aug 2007 11:56:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Michael Sedkowski <sedmich@gmail.com>, trenn@suse.de,
       Robert Hancock <hancockr@shaw.ca>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no> <1186514618.5622.9.camel@nx6310> <8db1092f0708071309h5cf6f68bo80b44d9a2fbeabeb@mail.gmail.com> <200708072233.52500.rjw@sisk.pl>
In-Reply-To: <200708072233.52500.rjw@sisk.pl>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Well, on my box (nx6325) with the appended (experimental) patch applied
> on top of 2.6.23-rc1 with the patchset from
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc2/patches/ , the
> double spin down doesn't occur during hibernation and the system is shut down
> notceably faster.

Can you please explain what the patch does?  So, I take it that entering
S4 also spins down the disk.  Does the patch remove the ACPI spin down
or libata one?

-- 
tejun
