Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbYK0QsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYK0QsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYK0QsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:48:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39408 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYK0QsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:48:02 -0500
Date: Thu, 27 Nov 2008 16:47:54 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default behaviour
Message-ID: <20081127164754.GC22963@srcf.ucam.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org> <20081127163535.775729bf@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127163535.775729bf@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 04:35:35PM +0000, Alan Cox wrote:

> Putting in extra flags to allow the kernel and user space to fight each
> other over mount defaults is a recipe for disaster. Take your userspace
> mount command and beat it up appropriately. If you want a mount command
> that defaults to relatime then ship a mount command that does.

Yes, that sounds like a reasonable approach. In that case I'll update 
the first to include the support for configuring the timeout.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
