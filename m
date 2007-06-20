Return-Path: <linux-kernel-owner+w=401wt.eu-S1759886AbXFTMwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbXFTMwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 08:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbXFTMwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 08:52:39 -0400
Received: from main.gmane.org ([80.91.229.2]:55840 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbXFTMwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 08:52:38 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC PATCH 1/4] Union mount documentation.
Date: Wed, 20 Jun 2007 12:43:56 +0000 (UTC)
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
Message-ID: <f5b7ec$f4g$1@sea.gmane.org>
References: <20070620055050.GB4267@in.ibm.com>
	<20070620055157.GC4267@in.ibm.com>
	<1182319191.2700.9.camel@laptopd505.fenrus.org>
	<f5al1i$foi$1@sea.gmane.org> <20070620123223.GB4620@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: charybdis-ext.suse.de
User-Agent: pan 0.119 (Karma Hunters)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 13:32:23 +0100, Christoph Hellwig wrote:

> On Wed, Jun 20, 2007 at 07:29:55AM +0000, Jan Blunck wrote:
>> Mounting a file system twice is bad in the first place. This should be
>> done by using bind mounts and bind a mounted file system into a union.
>> After that the normal locking rules apply (and hopefully work ;).
> 
> From the kernel POV mounting a filesystem twice is the same as doing
> a bind mount.

Somehow I thought about doing this:

 mount /dev/dasda1 /mnt/A
 mount /dev/dasda1 /mnt/B

... which doesn't result in a bind mount.

