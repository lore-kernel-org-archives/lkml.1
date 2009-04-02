Return-Path: <linux-kernel-owner+w=401wt.eu-S1761855AbZDBCOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761855AbZDBCOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZDBCOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:14:12 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:49088
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbZDBCOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:14:11 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Date: Wed, 1 Apr 2009 21:14:05 -0500
User-Agent: KMail/1.9.10
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
References: <200903120437.03837.rob@landley.net> <10f740e80904011323t219063b0ife4db1677ca0d22b@mail.gmail.com> <20090401225916.GZ3795@csclub.uwaterloo.ca>
In-Reply-To: <20090401225916.GZ3795@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904012114.07183.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009 17:59:16 Lennart Sorensen wrote:
> On Wed, Apr 01, 2009 at 10:23:06PM +0200, Geert Uytterhoeven wrote:
> > It entered mainline just before v2.6.29 (after v2.6.29-rc8)?
> > Or did you find a new problem?
>
> No, I just didn't check yet.  I am still solving uclibc issues, so
> 2.6.29-rc3 was still doing the job.

uClibc's working for me just fine.  Either grab the most recent build scripts 
from http://impactlinux.com/hg/firmware or grab the prebuilt binaries from 
http://impactlinux.com/fwl/downloads/snapshots/ (which has cross compilers, 
root filesystem tarballs, and system images bootable by qemu).

I haven't tested m68k yet because qemu doesn't support it (just coldfire), and 
aranym hasn't got a serial console, but it did compile using the same build 
scripts as all the other targets...

Rob
-- 
GPLv3 is to GPLv2 what Attack of the Clones is to The Empire Strikes Back.
