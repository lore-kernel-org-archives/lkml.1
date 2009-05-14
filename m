Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbZENPus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbZENPus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZENPuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:50:39 -0400
Received: from kroah.org ([198.145.64.141]:38397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZENPui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:50:38 -0400
Date: Thu, 14 May 2009 08:46:57 -0700
From: Greg KH <greg@kroah.com>
To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: staging fails in next-20090514: drivers/staging/agnx/pci.o
Message-ID: <20090514154657.GA2593@kroah.com>
References: <20090514164120.200e5fe2.sfr@canb.auug.org.au> <20090514152308.GB5880@ikn.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090514152308.GB5880@ikn.schottelius.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 05:23:08PM +0200, Nico -telmich- Schottelius wrote:
> Hehe, just found the staging area today, in which agnx does not want
> to be compiled:
> 
> 
>   CC [M]  drivers/staging/agnx/pci.o
> drivers/staging/agnx/pci.c:64:3: warning: "/*" within comment
> drivers/staging/agnx/pci.c:223:2: warning: "/*" within comment
> drivers/staging/agnx/pci.c:307: warning: ‘struct ieee80211_if_conf’ declared inside parameter list
> drivers/staging/agnx/pci.c:307: warning: its scope is only this definition or declaration, which is probably not what you want
> drivers/staging/agnx/pci.c: In function ‘agnx_config_interface’:
> drivers/staging/agnx/pci.c:315: error: dereferencing pointer to incomplete type

Known error, due to changes in the wireless tree.  Patches have been
sent to the wireless developer to help resolve these already.

thanks,

greg k-h
