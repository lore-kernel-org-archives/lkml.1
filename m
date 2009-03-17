Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZCQS71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZCQS71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZCQS7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:59:17 -0400
Received: from outbound-mail-308.bluehost.com ([67.222.53.254]:48905 "HELO
	outbound-mail-308.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752691AbZCQS7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:59:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MPyexQ9v5iTGJhHA1RFO0TakkVQARw/DQRZbFaVo71H+G8RBMNchyANJOz9ZXYPyxgpkh5R6eDIp2mn4OOTDJoIP4zncT1gsGg68SqizvvR3tsE6yrvxZLQ5LL0eAKQd;
Date: Tue, 17 Mar 2009 11:59:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jan Beulich <jbeulich@novell.com>, linux-pci@vger.kernel.org,
       Dexuan Cui <dexuan.cui@intel.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Fix the definition of PCI_PM_CTRL_NO_SOFT_RESET
Message-ID: <20090317115912.3063a93b@hobbes.lan>
In-Reply-To: <20090317173845.GR14127@parisc-linux.org>
References: <49BFDB3C.76E4.0078.0@novell.com>
	<20090317173845.GR14127@parisc-linux.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 11:38:45 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Tue, Mar 17, 2009 at 04:17:48PM +0000, Jan Beulich wrote:
> > From: Dexuan Cui <dexuan.cui@intel.com>
> > 
> > As per PCI Bus Power Management Interface Specification Revision 1.2
> > this is bit 3, not bit 2, of the Power Management Control/Status
> > register.
> 
> The same patch was already posted by Yu Zhao on February 25th and I
> reviewed it for Jesse.  I don't see it in any of the trees yet
> though ... (arguably, I should have picked it up for the fixes tree
> that I did while Jesse was away).

Yeah I've got it in my queue but haven't pushed it yet.  Thanks.


-- 
Jesse Barnes, Intel Open Source Technology Center
