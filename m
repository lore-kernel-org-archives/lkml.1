Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbYAVWPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbYAVWPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYAVWPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:15:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39670 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYAVWPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:15:19 -0500
Date: Tue, 22 Jan 2008 14:15:47 -0800
From: Greg KH <greg@kroah.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, davem@davemloft.net,
       schwidefsky@de.ibm.com, mingo@elte.hu, tony.luck@intel.com,
       paulus@samba.org
Subject: Re: [PATCH 1/3] constify struct attribute_group uses (against -mm)
Message-ID: <20080122221547.GA32588@kroah.com>
References: <4795FE39.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4795FE39.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 01:31:21PM +0000, Jan Beulich wrote:
> .. as all consumers of it don't require it to be modifiable.
> 
> Unfortunately, due to the two-level constifications, this required
> touching quite many files, not all of which I am able to test - please
> bare with eventual mistakes or oversights.
> 
> The patch doesn't change all instances where 'const' could have been
> added as a result of the base structure changes, only where either the
> change has a real effect (the module loader doesn't enforce read-only
> section attributes at present, so only built-in files matter) or where
> compiler warnings would result otherwise.

Which -mm is this against?  Seems to not apply here :(

thanks,

greg k-h
