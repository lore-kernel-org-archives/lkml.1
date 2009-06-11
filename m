Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZFKUlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZFKUlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZFKUlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:41:00 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38121 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZFKUlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:41:00 -0400
Date: Thu, 11 Jun 2009 22:43:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Magnus Damm <damm@igel.co.jp>, git-commits-head@vger.kernel.org
Subject: Re: sh: include empty_zero_page in text
Message-ID: <20090611204317.GA9120@uranus.ravnborg.org>
References: <200906111903.n5BJ32vd019484@hera.kernel.org> <20090611201048.GA8817@uranus.ravnborg.org> <20090611203316.GB832@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611203316.GB832@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > This change turned _text to be an absolute symbol.
> > Do you support rolocatable kernels then this may fail.
> > 
> It actually was an absolute before, while on sh64 it was not. We will
> probably need to do a bit of work with the empty zero page handling on
> these boards with older boot loaders to permit text to be positioned
> later down. The relocatable kernel support we have only started
> experimenting with, so yes, this is something that will have to be sorted
> out there as well.

OK - I noticed this and just wanted to be sure this was not an oversight.

	Sam
