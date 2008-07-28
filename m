Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbYG1U0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbYG1U0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYG1UZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:25:54 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43240 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752024AbYG1UZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:25:54 -0400
Date: Mon, 28 Jul 2008 16:25:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Narendra Prasad Madanapalli <narendramind@gmail.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: 64-bit rlimits
Message-ID: <20080728202526.GO9378@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Narendra Prasad Madanapalli <narendramind@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <85e5430e0807280821k1ec1f990te815c8eb4de19b61@mail.gmail.com> <20080728153029.GA14188@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728153029.GA14188@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 07:30:29PM +0400, Alexey Dobriyan wrote:
> Having in-kernel 32-bit AND 64-bit rlimits is plain wrong, sorry.

For backwards compatibility reasons, if we want to support 64-bit
rlimits on an 32-bit x86 architectures, it is inevitable.  It is the
only correct way to do things.

	      	     	 		      - Ted
