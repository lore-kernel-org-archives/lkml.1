Return-Path: <linux-kernel-owner+w=401wt.eu-S1030554AbXBZVdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030554AbXBZVdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030555AbXBZVdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:33:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:47797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030554AbXBZVdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:33:10 -0500
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: netconsole module cannot be removed
Date: Mon, 26 Feb 2007 13:31:56 -0800
Organization: OSDL
Message-ID: <20070226133156.3bfd2a74@freekitty>
References: <45E3447F.9080706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1172525516 11136 10.8.0.54 (26 Feb 2007 21:31:56 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Mon, 26 Feb 2007 21:31:56 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007 15:35:11 -0500
Chuck Ebbert <cebbert@redhat.com> wrote:

> Trying to remove netconsole, rmmod goes into a tight loop with
> 100% CPU usage. It can't be killed with 'kill -9'. Shutdown
> works, though. Kernel is 2.6.20 FC6 config, and I'm 99.9%
> sure the module signing has nothing to do with this.
> 

No it probably has to do with printing a message during module removal.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
