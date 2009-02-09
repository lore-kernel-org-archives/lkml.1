Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZBIEbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZBIEbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 23:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZBIEbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 23:31:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37882 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbZBIEbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 23:31:12 -0500
Message-ID: <498FB185.3070201@jp.fujitsu.com>
Date: Mon, 09 Feb 2009 13:31:01 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PCI/MSI: fix msi_mask() (rev. 2)
References: <498A5348.3090508@jp.fujitsu.com> <20090208112650.GD31509@parisc-linux.org> <498F89A7.9020208@jp.fujitsu.com> <20090209032747.GK31509@parisc-linux.org>
In-Reply-To: <20090209032747.GK31509@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Feb 09, 2009 at 10:40:55AM +0900, Hidetoshi Seto wrote:
>> The commit bffac3c593eba1f9da3efd0199e49ea6558a40ce ("PCI MSI: Fix
>> undefined shift by 32") does:
> 
> I think the commit message could be worded somewhat better, and I think
> I should be credited as the author of the patch.  How about this?
> 
> ----
> 
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> Hidetoshi Seto points out that commit
> bffac3c593eba1f9da3efd0199e49ea6558a40ce has wrong values in the
> array.  Rather than correct the array, we can just use a bounds check
> and perform the calculation specified in the comment.  As a bonus, this
> will not run off the end of the array if the device specifies an illegal
> value in the MSI capcbility.
                   ^^^^^^^^^^ capability

> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

It looks good for me other than the typo above.

Thanks,
H.Seto

