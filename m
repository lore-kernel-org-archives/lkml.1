Return-Path: <linux-kernel-owner+w=401wt.eu-S1761198AbXH0Tc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198AbXH0Tc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757725AbXH0Tcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:32:50 -0400
Received: from mail.fieldses.org ([66.93.2.214]:33104 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978AbXH0Tct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:32:49 -0400
Date: Mon, 27 Aug 2007 15:32:42 -0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Gabriel Barazer <gabriel@oxeva.fr>, nfsv4@linux-nfs.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jkar8572@users.sourceforge.net
Subject: Re: nfs4 filesystem mounted via the "bind" option reports wrong
	fstype
Message-ID: <20070827193242.GJ3118@fieldses.org>
References: <46D318D3.9020101@oxeva.fr> <20070827184059.GI3118@fieldses.org> <20070827191507.GI21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827191507.GI21089@ftp.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 08:15:07PM +0100, Al Viro wrote:
> On Mon, Aug 27, 2007 at 02:40:59PM -0400, J. Bruce Fields wrote:
>  
> > There's no reason not to just mount server:/exports/data directly at
> > /home/data; the bind mounts are just a workaround for the somewhat
> > primitive exports facility on the server side.
> 
> Bullshit.  Bindings are first-class operations on _client_, regardless
> of fs types involved.

I know.  Did I say something to the contrary?

Maybe I was too terse; in more detail: the original poster appears to be
mounting server:/exports/data by first mounting server:/ somewhere and
then bind-mounting the exports/data someplace else.  I couldn't see an
obvious reason they'd be using two steps instead of just performing a
single mount of server:/exports/data.

So my assumption was that this was due to a confused memory of some
server-side setup instructions.  (On the server side, nfs4 export setup
often requires the administrator to do some extra bind mounts which
shouldn't really be necessary.)

--b.
