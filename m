Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030867Ab0B1DUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 22:20:32 -0500
Received: from kroah.org ([198.145.64.141]:33463 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968697Ab0B1DUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 22:20:30 -0500
Date: Sat, 27 Feb 2010 19:19:27 -0800
From: Greg KH <greg@kroah.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.33 Bugs (CUSE)
Message-ID: <20100228031927.GA2057@kroah.com>
References: <d9def9db1002270536t76b7c262u7bc389fe245e5c85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db1002270536t76b7c262u7bc389fe245e5c85@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 02:36:54PM +0100, Markus Rechberger wrote:
> Hi,
> 
> following comes up when cusexmp gets started twice:
> $ ./cusexmp --name=foo /foo

Yeah, it's a known issue.  We have a patch queued up for .34 that will
resolve it, but we need to have it bake a bit more to ensure that there
are no bad problems.  If not, it will be added to the .33-stable
release.

thanks,

greg k-h
