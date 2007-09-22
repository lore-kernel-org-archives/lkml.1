Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbXIVUin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbXIVUin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbXIVUig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:38:36 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56563 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbXIVUig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:38:36 -0400
Date: Sat, 22 Sep 2007 22:40:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unfortunate infinite make recursion
Message-ID: <20070922204002.GA31873@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0709221319440.15712@fbirervta.pbzchgretzou.qr> <E1IZ788-0003LZ-Qs@flower>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IZ788-0003LZ-Qs@flower>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 05:42:52PM +0200, Oleg Verych wrote:
> * Sat, 22 Sep 2007 13:24:32 +0200 (CEST)
> []
> > The make O=$PWD truncates the Makefile, making it necessary to run `git 
> > checkout Makefile` - should you have git; or reextract the tarball 
> > (should you /still/ have it). Well, can we catch this case somehow?
> 
> Read-only source-tree for kbuild user, end of question. By current kbuild
> one can garbage source by various means. Read-write for quilt, git and
> editor users.

Please Oleg.
You know very well that most people will not have their kernel src RO.

	Sam
