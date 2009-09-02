Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZIBWaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZIBWaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 18:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbZIBWaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 18:30:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:59914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbZIBWaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 18:30:13 -0400
Message-ID: <4A9EF1E6.9010002@kernel.org>
Date: Thu, 03 Sep 2009 07:29:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Shane Huang <Shane.Huang@amd.com>
Subject: Re: [PATCH] pci: separate out pci_add_dynid()
References: <4A9E38FA.3000506@kernel.org> <20090902133020.GA25201@kroah.com>
In-Reply-To: <20090902133020.GA25201@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 22:30:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

Greg KH wrote:
>> +EXPORT_SYMBOL(pci_add_dynid);
> 
> scripts/checkpatch.pl will complain about this :)
> 
> Care to mark it EXPORT_SYMBOL_GPL() please?

Yeap, I just moved the code a bit so was a bit hesitant to add _GPL
there when all other functions didn't have it.  Oh well, it's not like
external drivers would it.  I'll.

> With that change, then feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks.

-- 
tejun
