Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYJGWNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYJGWNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 18:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYJGWNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 18:13:09 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37087 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754618AbYJGWNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 18:13:08 -0400
Date: Tue, 7 Oct 2008 18:12:56 -0400
From: Theodore Tso <tytso@mit.edu>
To: Quentin Godfroy <godfroy@clipper.ens.fr>
Cc: Eric Sandeen <sandeen@redhat.com>,
       Quentin Godfroy <godfroy@clipper.ens.fr>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Message-ID: <20081007221256.GF15929@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Quentin Godfroy <godfroy@clipper.ens.fr>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080930211854.GZ10831@mit.edu> <20080930222358.1FF30EAC415@quatramaran.ens.fr> <20081003003548.GA18138@mit.edu> <20081005091526.GA678@goelette.ens.fr> <20081005122752.GB27335@mit.edu> <20081005161214.GA2985@goelette.ens.fr> <20081006025006.GA9289@mit.edu> <48EA2F20.7020309@redhat.com> <20081006175502.GA12937@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006175502.GA12937@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 01:55:02PM -0400, Theodore Tso wrote:
> Here are updates to the two patches I sent you.  The first fixes some
> printk labels and requires that the debugging dump ioctl be triggered
> by root; the second fixes the think-o that Eric pointed out earlier
> this morning.

Hey Quentin, just wanted to check in and find out if the patches seem
to be working for you.  They seem to solve the problem on my side; I
can no longer reproduce the problem.  Is it working for you?

Thanks, regards,

       	      		    	      	    - Ted
