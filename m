Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbXEONPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbXEONPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 09:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbXEONPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 09:15:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:49154 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbXEONPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 09:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ghqcWqzGte+TCEC2gdKgRME4zENFsuZRYTCjX0MiAT6/1ffhvLlkc3wxpDoKFVuIgCgpO4XwanjidqndxanXBPJRFYLyeRUyaP1/k99+zLwNXHCtB98Hdo0tKm+GnNGwSAfKJgDgwdn7K/xaITjySYXnuGoTYD+HpkNOu+ieuYU=
Message-ID: <4649B270.8050002@gmail.com>
Date: Tue, 15 May 2007 17:15:28 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Greg KH <greg@kroah.com>
Subject: Re: pci probe
References: <4648B29A.6080406@gmail.com>
In-Reply-To: <4648B29A.6080406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manu Abraham wrote:
> Hi,
> 
> I do have a device that's a multifunction device. Eventhough a MFD, it
> just has one Interrupt which is shared by by a Configuration space for
> each function. ie, INTA is shared between them functions.
> 
> In such a case, i am wondering, (since pci_probe returns a pointer to
> one PCI function alone and i need to use both the functions in one
> module alone rather than using a module for each function and that the
> functions are quite similar for them to be used in different modules,
> such that a separate probe/ISR etc is used) whether using pci_get_device
> would be a better alternative to do manual searching for the functions
> in such a case.
> 

Just figured out that pci_get_subsys() does work in a better. Looking at
kernel sources all i find is just one single user of pci_get_subsys()

building the code around pci_get_subsys(), does this have any negative
impact ?

Thanks,
Manu
