Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbXH0TP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbXH0TP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbXH0TPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:15:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39227 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbXH0TPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:15:15 -0400
Date: Mon, 27 Aug 2007 20:15:07 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Gabriel Barazer <gabriel@oxeva.fr>, nfsv4@linux-nfs.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jkar8572@users.sourceforge.net
Subject: Re: nfs4 filesystem mounted via the "bind" option reports wrong fstype
Message-ID: <20070827191507.GI21089@ftp.linux.org.uk>
References: <46D318D3.9020101@oxeva.fr> <20070827184059.GI3118@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827184059.GI3118@fieldses.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 02:40:59PM -0400, J. Bruce Fields wrote:
 
> There's no reason not to just mount server:/exports/data directly at
> /home/data; the bind mounts are just a workaround for the somewhat
> primitive exports facility on the server side.

Bullshit.  Bindings are first-class operations on _client_, regardless
of fs types involved.
