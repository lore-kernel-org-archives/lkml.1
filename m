Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZDMTyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZDMTyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZDMTym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:54:42 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:45999 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZDMTyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:54:41 -0400
Date: Mon, 13 Apr 2009 22:54:37 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Krishna Gopal <linuxkrishna@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux coding standards - User space
Message-ID: <20090413195437.GM28512@mea-ext.zmailer.org>
References: <68f510a70904131210s38188475ie878f2775d92cab6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68f510a70904131210s38188475ie878f2775d92cab6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 02:10:48PM -0500, Krishna Gopal wrote:
> 
> Are there any coding guidelines for Linux User space programming ?
> 

No.  The problem space is way too large.

Understand the problem being solved, use tools you know how, learn better
ones when necessary, try using existing tools.  Do not recreate the wheel
(write new program code) without good reason. This results often in amazing
number of libraries needed for even _simple_ programs to work, which itself
has become a problem.

Trade that code self-writing/copying against the number of needed libraries,
and their source licenses.   Self-written and copied codes are prone to
errors, which does not mean that popular libraries are immuned to errors
either, but getting library fixed does fix all programs using that library.

I am hyper-conservative myself to add any new library into use.  The less
libraries the code uses, the better is its portability to new platforms.
I myself do not consider locking application code to only Linux being 
acceptable, it is more sign of its coder having too narrow thinking.

Portability among different flavours of UNIX may need surprising things,
and $BigMoney applications get to run in POSIX systems that often are not
Linux.  Sometimes even on Windows.

> BR,
> Krishna

BR, Matti
