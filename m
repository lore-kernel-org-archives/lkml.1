Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbZCaTbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbZCaTbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZCaTb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:31:28 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33897
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZCaTb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:31:27 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Squashfs 4.0 tools
Date: Tue, 31 Mar 2009 14:31:18 -0500
User-Agent: KMail/1.9.10
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-kernel@vger.kernel.org, squashfs-devel@lists.sourceforge.net
References: <20090323180808.2c2ef1a7@nehalam> <10f740e80903290202h1f36b370ga39721536d52a90@mail.gmail.com> <20090330175524.4e8f802e@nehalam>
In-Reply-To: <20090330175524.4e8f802e@nehalam>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311431.20494.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009 19:55:24 Stephen Hemminger wrote:
> I built it from cvs (imported into git), and it works okay.

I grabbed the cvs snapshot gentoo's been using, but I don't see any way to 
feed in a device list text file so I can create the /dev/console node root 
filesystems need without needing root access on the host to mknod.

genext2fs has the -D option, which takes:

  /dev d 755 0 0 - - - - -
  /dev/console c 640 0 0 5 1 0 0 -

gen_init_cpio takes:

  dir /dev 755 0 0
  nod /dev/console 660 0 0 c 5 1

Is there a squashfs option I'm missing...?

Rob
-- 
GPLv3 is to GPLv2 what Attack of the Clones is to The Empire Strikes Back.
