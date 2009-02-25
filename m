Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbZBYP5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbZBYP5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbZBYP4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:56:39 -0500
Received: from thunk.org ([69.25.196.29]:46663 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759436AbZBYP4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:56:37 -0500
Date: Wed, 25 Feb 2009 10:56:28 -0500
From: Theodore Tso <tytso@mit.edu>
To: Yang Hongyang <imhy.yang@gmail.com>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
       mtk.manpages@gmail.com, rdunlap@xenotime.net
Subject: Re: Documentation:Update the INDEX of the documents
Message-ID: <20090225155628.GM7064@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Yang Hongyang <imhy.yang@gmail.com>,
	Yang Hongyang <yanghy@cn.fujitsu.com>, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, mtk.manpages@gmail.com,
	rdunlap@xenotime.net
References: <49A4F06B.6030205@cn.fujitsu.com> <20090225145950.GJ7064@mit.edu> <a669f14b0902250725j4c21463eqc1b88092486f38ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a669f14b0902250725j4c21463eqc1b88092486f38ad@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 11:25:08PM +0800, Yang Hongyang wrote:
> > If folks do find the 00-INDEX files useful, my suggestion would be to
> > make a way of automatically extracting them from the individual files
> > and/or directories, and then making the 00-INDEX files to be
> > automatically generated.
> 
> Sounds like a good idea but How to automatically generate
>  the summaries then?

Well, for text files (including subdirectory's 00-INDEX files) we
could have a convention which is the first line of the file should be
a (max 60 characters) one-line summary of the file.

We would probably have to do something special with non-free-form-text
files, including structured text files like Docbook files.  So it's
not quite so straightforward, but it should be doable.

    	     		      	     	       - Ted
