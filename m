Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZKLLIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZKLLIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZKLLIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:08:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39663 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751399AbZKLLIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:08:10 -0500
Date: Thu, 12 Nov 2009 11:09:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Robert Hancock <hancockrwd@gmail.com>, "Anton D. Kachalov" <mouse@mayc.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
Message-ID: <20091112110949.339c0c64@lxorguk.ukuu.org.uk>
In-Reply-To: <20091112021209.GA21625@khazad-dum.debian.net>
References: <4AFACC03.7080209@mayc.ru>
	<4AFB2822.30906@gmail.com>
	<20091112021209.GA21625@khazad-dum.debian.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 00:12:09 -0200
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Wed, 11 Nov 2009, Robert Hancock wrote:
> > I don't think that we prevent any access to device registers in
> > /dev/mem - if you read something that has side effects and something
> > breaks, well I guess you get to keep both pieces :-) There's a
> > reason it's root-only..
> 
> We should.  Imaging /dev/mem is one of the oldest tricks in the book of the
> forensics people, they do it to live systems to help track down WTF happened
> to a compromised host.  This kind of crap bites them hard.

Any forensics person who images /dev/mem needs to go back to school.

Alan
