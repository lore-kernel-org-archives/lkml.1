Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbYBRI1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbYBRI1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYBRI1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:27:16 -0500
Received: from hall.aurel32.net ([88.191.38.19]:44055 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbYBRI1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:27:15 -0500
X-Greylist: delayed 2233 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2008 03:27:15 EST
Date: Mon, 18 Feb 2008 08:49:44 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: mips/bcm47xx/setup.c compile error
Message-ID: <20080218074944.GA9317@hall.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	Adrian Bunk <bunk@kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>, ralf@linux-mips.org,
	linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
References: <20080217200947.GH1403@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080217200947.GH1403@cs181133002.pp.htv.fi>
X-Mailer: Mutt 1.5.13 (2006-08-11)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 10:09:47PM +0200, Adrian Bunk wrote:
> Commit d3c319f9c8d9ee2c042c60b8a1bbd909dcc42782 causes the following 
> compile error:
> 
> <--  snip  -->
> 
> ...
>   CC      arch/mips/bcm47xx/setup.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c: In function 'bcm47xx_get_invariants':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:95: error: 'struct ssb_sprom' has no member named 'r1'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:97: error: 'struct ssb_sprom' has no member named 'r1'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:99: error: 'struct ssb_sprom' has no member named 'r1'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:101: error: 'struct ssb_sprom' has no member named 'r1'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:103: error: 'struct ssb_sprom' has no member named 'r1'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:105: error: 'struct ssb_sprom' has no member named 'r1'
> make[2]: *** [arch/mips/bcm47xx/setup.o] Error 1
> 

It has been broken by commit d3c319f9c8d9ee2c042c60b8a1bbd909dcc42782. I
am working on a fix.


-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
