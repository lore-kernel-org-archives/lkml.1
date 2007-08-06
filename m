Return-Path: <linux-kernel-owner+w=401wt.eu-S1765651AbXHFSVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765651AbXHFSVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbXHFSVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:21:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:14818 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbXHFSVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m0NTsgDbKI93L/zT7JP9ohufq44SxSLGfostB87quEHzoSfz96BwSVnmlHRLgbdTWKSqAnLxnqupodgq8GHjxTjfiaYMFFX/KjiKJ2D8EgHAmx5idi/kPZKvXXaaUljgzpaZdNmk28DxTmhTp6lDOotbIUL1R7u6kmg1ZYbK+TU=
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Michael Sedkowski <sedmich@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <46B75459.9020204@gmail.com>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>
	 <1186411815.4355.7.camel@nx6310>
	 <20070806150159.GC31615@khazad-dum.debian.net>
	 <200708061732.03425.rjw@sisk.pl>  <46B75459.9020204@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 06 Aug 2007 20:21:32 +0200
Message-Id: <1186424492.4355.1.camel@nx6310>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 07-08-2007, Wt o godzinie 02:03 +0900, Tejun Heo napisał(a):
> Rafael J. Wysocki wrote:
> >>> Sidux is a Debian Unstable based distro with it's own set of patches
> >>> including the shut down patch provided here:
> >>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=426224
> >> You'll probably have to ask Sidux what changes they made that could cause
> >> the double spin down, even if halt(8) is never passed the -h flag.
> > 
> > Well, I've been observing the same behavior on nx6325 for some time and I
> > use openSUSE 10.2.  I think this is kernel-related.
> 
> Hmmm... If the problem only shows up on nx6325, it might be that ACPI is
> pulling unnecessary stunt.  Please apply the attached patch and report
> when the disk spins down and up.
> 
> Thanks.
> 

Disk spins down on "Pre-shutdown prepare" and then goes up and down on
"Power down".

