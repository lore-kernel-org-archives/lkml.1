Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZEGEjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZEGEjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 00:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZEGEiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 00:38:50 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:52234 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZEGEit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 00:38:49 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir 
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090506202050.GK9861@fieldses.org>
References: <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <7321.1240375306@jrobl> <20090422191244.GD9541@fieldses.org> <9180.1240468823@jrobl> <20090423202705.GA31085@fieldses.org> <20090505233509.GG27790@fieldses.org> <7475.1241586545@jrobl> <20090506202050.GK9861@fieldses.org>
Date: Thu, 07 May 2009 13:38:27 +0900
Message-ID: <7342.1241671107@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"J. Bruce Fields":
> I wonder if it'd be simpler just to keep the loookup_one_len() in
> nfsd4_encode_dirent() and just be prepared to roll back the encoding
> we've already done if we find out at that point the dentry has gone
> negative.  Actually, that doesn't look hard.
> 
> Thanks for looking at this!

The patch looks much better than before, and more than I expected. :-)


J. R. Okajima
