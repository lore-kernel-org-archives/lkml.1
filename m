Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYHLTal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYHLTal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYHLTac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:30:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYHLTac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:30:32 -0400
Date: Tue, 12 Aug 2008 15:30:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mimi Zohar <zohar@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       sailer@watson.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       serue@linux.vnet.ibm.com, Al Viro <viro@ZenIV.linux.org.uk>,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Kenneth Goldman <kgold@watson.ibm.com>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
Message-ID: <20080812193031.GD18034@infradead.org>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221718.4444.11.camel@localhost.localdomain> <20080809184622.GA22905@infradead.org> <OF9A2A62B8.D4E0AE57-ON852574A2.006CEDC6-852574A2.00749DAC@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF9A2A62B8.D4E0AE57-ON852574A2.006CEDC6-852574A2.00749DAC@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 05:13:51PM -0400, Mimi Zohar wrote:
> 
> I assume the concern here is that between looking up the chip and actually 
> 
> using the chip, the TPM chip is disabled/deactivated.  Based on 
> discussions 
> with Kenneth Goldman, the TCG main specification part2: structures, 
> require
> that even if the TPM is disabled/deactivated, the command to extend the 
> PCR 
> will succeed, but the command to read the PCR will fail with an 
> appropriate 
> error code.

And what happens when the chip simply goes away due to a hotplug action?
Or not even the actual chip goes away but just the chip driver and you
now dereference freed memory?

