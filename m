Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbXF3JpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbXF3JpC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:45:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbXF3Jow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:44:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58506 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbXF3Jov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:44:51 -0400
Date: Sat, 30 Jun 2007 10:44:46 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] VFS: Augment /proc/mount with subroot and shared-subtree
Message-ID: <20070630094446.GB22889@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ram Pai <linuxram@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Al Viro <viro@ftp.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
References: <20070620210343.GQ21478@ftp.linux.org.uk> <46799A31.10301@zytor.com> <1182442837.3342.13.camel@ram.us.ibm.com> <467AB5EE.3030909@zytor.com> <1182494654.2812.22.camel@ram.us.ibm.com> <467B7509.8010106@zytor.com> <1182497690.2812.54.camel@ram.us.ibm.com> <467B7F6F.4030007@zytor.com> <20070625214640.GC29058@ram.us.ibm.com> <1182808816.2816.7.camel@ram.us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182808816.2816.7.camel@ram.us.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 03:00:15PM -0700, Ram Pai wrote:
> Please check if the following modified patch meets the requirements.
> 
> It augments /proc/mount with additional information to
> 	(1) disambiguate bind mounts with subroot information.
> 	(2) display shared-subtree information using which one can
> 		determine the propagation trees.
> 
> 
> The following additional fields are appended to each record
> in /proc/mounts

NACK.  Adding anything to the format will confuse the hell out of
existing parsers.  We really want something like your /proc/<pid>/mounts_new,
except mounts_new should have a better name (/proc/<pid>/ns anyone? :))

