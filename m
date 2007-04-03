Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbXDCFL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbXDCFL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXDCFL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:11:58 -0400
Received: from crown.reflexsecurity.com ([72.54.139.163]:40029 "EHLO
	crown.reflexsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXDCFL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:11:58 -0400
X-Greylist: delayed 1632 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 01:11:58 EDT
X-Reflex-Keepalives: .
Date: Tue, 3 Apr 2007 00:44:47 -0400
From: Jason Lunz <lunz@falooley.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: roland <devzero@web.de>, Antoine Martin <antoine@nagafix.co.uk>,
       Blaisorblade <blaisorblade@yahoo.it>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel release ?
Message-ID: <20070403044447.GB14297@falooley.org>
References: <1712880100@web.de> <200704012108.14597.blaisorblade@yahoo.it> <46100EF5.7040802@nagafix.co.uk> <20070402020530.GA589@c2.user-mode-linux.org> <4610D937.20002@nagafix.co.uk> <005601c77567$1ceddb60$eeeea8c0@aldipc> <20070402214434.GA10205@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402214434.GA10205@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 05:44:34PM -0400, Jeff Dike wrote:
> There are sites (http://uml.nagafix.co.uk/ being the best one I know
> of) where, with two downloads, two uncompressions, and one command
> line later, you have a booted UML.
> 
> The only way I know of to improve on this, aside from inprovements in
> the booted distro, is to package the filesystem as a rootfs within the
> UML kernel binary.  I've considered this, but haven't done anything
> with it.

I've done the converse: package the uml kernel within the rootfs image,
and use a script that plays the part of bootloader. With ext2 at least,
it's fairly easy to use the debugfs 'cat' command for this.

That way, you simply distribute the fs image with a companion script
that can boot any number of such images.

Jason
