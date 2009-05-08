Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbZEHSsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbZEHSsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932259AbZEHSrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:47:48 -0400
Received: from mail.fieldses.org ([141.211.133.115]:50972 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbZEHSrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:47:47 -0400
Date: Fri, 8 May 2009 14:47:37 -0400
To: hooanon05@yahoo.co.jp
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir
Message-ID: <20090508184737.GG20539@fieldses.org>
References: <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <7321.1240375306@jrobl> <20090422191244.GD9541@fieldses.org> <9180.1240468823@jrobl> <20090423202705.GA31085@fieldses.org> <20090505233509.GG27790@fieldses.org> <7475.1241586545@jrobl> <20090506202050.GK9861@fieldses.org> <7342.1241671107@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7342.1241671107@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 01:38:27PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> "J. Bruce Fields":
> > I wonder if it'd be simpler just to keep the loookup_one_len() in
> > nfsd4_encode_dirent() and just be prepared to roll back the encoding
> > we've already done if we find out at that point the dentry has gone
> > negative.  Actually, that doesn't look hard.
> > 
> > Thanks for looking at this!
> 
> The patch looks much better than before, and more than I expected. :-)

OK, thanks, I'll submit it to 2.6.30 and .29.

--b.
