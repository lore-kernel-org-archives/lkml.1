Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZIUUzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZIUUzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 16:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbZIUUzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 16:55:06 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:47884 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbZIUUzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 16:55:05 -0400
Date: Mon, 21 Sep 2009 21:55:52 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Kevin D. Kissell" <kevink@paralogos.com>
Cc: Julia Lawall <julia@diku.dk>, dmitri.vorobiev@gmail.com,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/mips: remove duplicate structure field
	initialization
Message-ID: <20090921205551.GA20341@linux-mips.org>
References: <Pine.LNX.4.64.0909211708200.8549@pc-004.diku.dk> <20090921192520.GB17310@linux-mips.org> <4AB7E0D1.10506@paralogos.com> <4AB7E50D.4090509@paralogos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB7E50D.4090509@paralogos.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 01:41:49PM -0700, Kevin D. Kissell wrote:

> Ha!  Found the breakage.  It wasn't a two-phase commit.  It was just an  
> overworked mantainer in a hurry, in July 2007.  See commit  
> 033890b084adfa367c544864451d7730552ce8bf

An overworked maintainer in cooperation with a broken compiler.  Worse -
it's not the first time this type of bug strikes but probably this was
never brought to the gcc maintainers' attention.

  Ralf
