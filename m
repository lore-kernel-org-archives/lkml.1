Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbXEPNgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbXEPNgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760264AbXEPNfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:35:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2061 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758897AbXEPNfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:35:44 -0400
Date: Tue, 15 May 2007 09:14:44 +0000
From: Pavel Machek <pavel@ucw.cz>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Message-ID: <20070515091443.GD6816@ucw.cz>
References: <20070514110607.549397248@suse.de> <20070514110621.316630438@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514110621.316630438@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Module parameters, LSM hooks, initialization and teardown.
> 
> Signed-off-by: John Johansen <jjohansen@suse.de>
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

> +/* Maximum pathname length before accesses will start getting rejected */
> +unsigned int apparmor_path_max = 2 * PATH_MAX;
> +module_param_named(path_max, apparmor_path_max, aauint, S_IRUSR | S_IWUSR);
> +MODULE_PARM_DESC(apparmor_path_max, "Maximum pathname length allowed");

WTF? Why is this configurable?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
