Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZBIRYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZBIRYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZBIRXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:23:54 -0500
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:52735 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753185AbZBIRXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:23:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=C9DXxVNjwmG9HHpfHH9qhNQUgI6vO/39YAOHcC8S6Bsi0bczt8I97MemSiggc8MDkdUXKj1PAUaWVGADpbsJHAKupF+ZA2PpI1wqD+eJd9fwD36Vgm58CzVtW6Q2uKJY;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] PCI/MSI: fix msi_mask() (rev. 2)
Date: Mon, 9 Feb 2009 09:23:50 -0800
User-Agent: KMail/1.9.10
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
References: <498A5348.3090508@jp.fujitsu.com> <498F89A7.9020208@jp.fujitsu.com> <20090209032747.GK31509@parisc-linux.org>
In-Reply-To: <20090209032747.GK31509@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902090923.51160.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 8, 2009 7:27 pm Matthew Wilcox wrote:
> On Mon, Feb 09, 2009 at 10:40:55AM +0900, Hidetoshi Seto wrote:
> > The commit bffac3c593eba1f9da3efd0199e49ea6558a40ce ("PCI MSI: Fix
> > undefined shift by 32") does:
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
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Applied to my for-linus branch, thanks guys.

-- 
Jesse Barnes, Intel Open Source Technology Center
