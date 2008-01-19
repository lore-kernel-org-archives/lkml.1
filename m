Return-Path: <linux-kernel-owner+w=401wt.eu-S1764639AbYASB33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764639AbYASB33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759933AbYASB3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:29:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42313 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856AbYASB3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:29:03 -0500
Date: Fri, 18 Jan 2008 17:26:36 -0800
From: Greg KH <greg@kroah.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, schwidefsky@de.ibm.com,
       mingo@elte.hu, tony.luck@intel.com, paulus@samba.org, gregkh@suse.de
Subject: Re: [PATCH 1/3] constify struct attribute_group uses
Message-ID: <20080119012636.GA6150@kroah.com>
References: <478738F3.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478738F3.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 08:37:55AM +0000, Jan Beulich wrote:
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

Hm, code in these areas has changed a lot in -mm, can you respin this
against that tree to catch all of the different attribute changes that
has happened?

thanks,

greg k-h
