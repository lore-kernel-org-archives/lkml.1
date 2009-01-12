Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbZALTQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbZALTQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZALTQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:16:25 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:60191 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbZALTQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:16:24 -0500
Date: Mon, 12 Jan 2009 20:18:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: .config - is the time really necessary
Message-ID: <20090112191805.GA14242@uranus.ravnborg.org>
References: <20090112185739.GQ12431@fluff.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112185739.GQ12431@fluff.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 06:57:39PM +0000, Ben Dooks wrote:
> Line 3 of the .config files has the current date in it. Is this
> information of any use to anyone? It makes life difficult when
> producing series of patches that touches a defconfig, as you end
> up with conflicts if you go back and change/remove/add one to the
> series.
> 
> Would people object to the time/date being removed from the .config
> file?

From: Documentation/kbuild/kconfig.txt:

KCONFIG_NOTIMESTAMP
--------------------------------------------------
If this environment variable exists and is non-null, the timestamp line
in generated .config files is omitted.


	Sam
