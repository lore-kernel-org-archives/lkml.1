Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbXJXHw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbXJXHw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbXJXHwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:52:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:14060 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXJXHwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WsMAoY3xnTJ+/nlaBUSbVXxJmoL4wty63KEzDQnXqm+Wd4+kpG6hsiZL2yX940MwyPnoNXaB4RPoYTP9TeOokTESmsgDKg5/4Nr9+W7Nqo4s6ycw2uuL8O3qRk9jSLga04YbGYBquBfrurvTZ+3GqQb3E9OJDcEoNvNDAGHcaOU=
Message-ID: <471EF9CD.6070400@gmail.com>
Date: Wed, 24 Oct 2007 09:52:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: joncglenn <joncglenn@hotmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Mapping PCI memory to user-space
References: <13380086.post@talk.nabble.com>
In-Reply-To: <13380086.post@talk.nabble.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2007 08:59 AM, joncglenn wrote:
> I am writing a driver to map a PCI board memory space (pcibar2) into a
> user-space vma via 'mmap'.  What is the relationship between the address
> returned from ioremap and the type of address needed in the
> 'io_remap_page_range' or 'remap_pfn_range' functions?  How about the
> following? (I am developing under RHEL4 and a 2.6.9 kernel)

I think you can use the method used for exporting pci resources in /sys. See
pci_mmap_resource. Don't know if this was yet in 2.6.9...

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
