Return-Path: <linux-kernel-owner+w=401wt.eu-S1762350AbXGKPpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350AbXGKPpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbXGKPpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:45:41 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38059 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbXGKPpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:45:39 -0400
Subject: Re: [RFC PATCH 1/1] VFS: Augment /proc/mount with subroot and
	shared-subtree
From: Ram Pai <linuxram@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
In-Reply-To: <20070711102449.GA22185@infradead.org>
References: <1182442837.3342.13.camel@ram.us.ibm.com>
	 <467AB5EE.3030909@zytor.com> <1182494654.2812.22.camel@ram.us.ibm.com>
	 <467B7509.8010106@zytor.com> <1182497690.2812.54.camel@ram.us.ibm.com>
	 <467B7F6F.4030007@zytor.com> <20070625214640.GC29058@ram.us.ibm.com>
	 <1182808816.2816.7.camel@ram.us.ibm.com>
	 <20070630094446.GB22889@infradead.org> <468652E2.4050901@zytor.com>
	 <20070711102449.GA22185@infradead.org>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 08:42:21 -0700
Message-Id: <1184168542.2844.13.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 11:24 +0100, Christoph Hellwig wrote:
> On Sat, Jun 30, 2007 at 08:56:02AM -0400, H. Peter Anvin wrote:
> > Is that conjecture, or do you have evidence to that effect?  Most users 
> > of this file are using it via the glibc interfaces, and there probably 
> > aren't all that many users of it in the first place.
> 
> I have written parsers for personal projects that might not have been
> happy to deal with additional fields myself for example..

I modified the patch to add fields towards the end of each line.
i.e after 'freq, passno' fields. And symlinked /etc/mtab
to /proc/mounts.
mount,df  and friends were all perfectly happy.  

I imagine your script may also be happy with the additional fields
**towards the end**. I would like to avoid one more mount interface if
we can help it.

RP



