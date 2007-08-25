Return-Path: <linux-kernel-owner+w=401wt.eu-S1763015AbXHYBPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763015AbXHYBPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 21:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbXHYBP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 21:15:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54673 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbXHYBP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 21:15:28 -0400
Date: Sat, 25 Aug 2007 02:15:24 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Paul Mackerras <paulus@samba.org>
Cc: Olaf Hering <olaf@aepfle.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] fix undefined reference to device_power_up/resume
Message-ID: <20070825011524.GX21089@ftp.linux.org.uk>
References: <20070824194201.GA8737@aepfle.de> <18127.33141.119362.34178@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18127.33141.119362.34178@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 11:10:13AM +1000, Paul Mackerras wrote:
> Olaf Hering writes:
> 
> > So change even more places from PM to PM_SLEEP to allow linking.
> 
> What config shows these errors?  I presume you need to have CONFIG_PM
> but not CONFIG_PM_SLEEP in order to see them?

E.g. PM, PPC32, SMP.
