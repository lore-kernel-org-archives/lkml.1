Return-Path: <linux-kernel-owner+w=401wt.eu-S934647AbXHORbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647AbXHORbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934483AbXHORam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:30:42 -0400
Received: from sidhe.atheme.org ([204.15.224.234]:58666 "EHLO sidhe.atheme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764614AbXHORak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:30:40 -0400
Message-ID: <46C33835.90703@partiallystapled.com>
Date: Wed, 15 Aug 2007 13:30:29 -0400
From: Michael Tharp <gxti@partiallystapled.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070723)
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: alan <alan@clueserver.org>, linux-kernel@vger.kernel.org
Subject: Re: Thinking outside the box on file systems
References: <249938.3918.qm@web52506.mail.re2.yahoo.com>
In-Reply-To: <249938.3918.qm@web52506.mail.re2.yahoo.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> That not a problem - it's a feature. In such a
> situation the person would get a general file creation
> error.

Feature or not, it's still vulnerable to probing by malicious users. If
there are create permissions on the directory, the invisibility is not
perfect.

> Although it isn't likely people would structure
> files with invisible files in directories that the
> user has create permissions [...]

... /tmp ...

> [...] it is logical that if I
> put a file in a place where the user has no rights I
> want it to stay there. Currently the user can delete
> files where they have no rights.

Indeed. The sticky bit works around this, but IMHO it's a hack.

> I might also want to restrict the kind of a user can
> createor give permission to create only certian file
> names.
> 
> /etc/vz/conf/*.conf - create - readonly - self-rw
> /etc/vz/conf - deny 
> 
> This would allow the user to read all *.conf files,
> create new *.conf files, and full permissions to
> read/write/delete files that the user created but not
> files that others created. If listing a directory then
> only the *.conf files would appear even if other files
> are in the directory.

It'd be interesting to find a use case for this, but that's no reason
not to provide the functionality.

> Marc Perkel
> Junk Email Filter dot com
> http://www.junkemailfilter.com

  -- m. tharp
