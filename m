Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZIIRU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZIIRU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZIIRU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:20:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbZIIRUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:20:25 -0400
Date: Wed, 9 Sep 2009 10:03:45 -0700
From: Greg KH <gregkh@suse.de>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [PATCH] kobject_set_name: free old_name in case of ENOMEM
Message-ID: <20090909170345.GA15866@suse.de>
References: <alpine.LFD.2.00.0909091838080.3303@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909091838080.3303@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 06:53:21PM +0200, Sebastian Ott wrote:
> 
> If the memory allocation for the kobject's name fails we should free
> the old_name since it is no longer accessible via kobj->name.

Hasn't this come up a bunch in the past, and we do not want to do this?

You might want to search the lkml archives for details...

thanks,

greg k-h
