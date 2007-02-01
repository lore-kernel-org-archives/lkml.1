Return-Path: <linux-kernel-owner+w=401wt.eu-S1030471AbXBAAit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030471AbXBAAit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030481AbXBAAit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:38:49 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:34040 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030471AbXBAAis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:38:48 -0500
Date: Wed, 31 Jan 2007 16:38:40 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20-rc6-mm3
In-Reply-To: <20070131163638.290f40c1.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701311637100.12104@schroedinger.engr.sgi.com>
References: <20070129204528.eb8d695e.akpm@osdl.org>
 <Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com>
 <20070131162422.6bccc52c.akpm@osdl.org> <Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com>
 <20070131163638.290f40c1.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007, Andrew Morton wrote:

> Actually, we might not have lost an IO: it could be that we're simply
> missing an unplug.  Are you able to unblock things by forcing some other IO
> against that queue?  Say, do a read from /dev/sda?

The system does not come up to a prompt. The traces were taken via NMI 
during bootup (shortly after udev came up).

