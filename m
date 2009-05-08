Return-Path: <linux-kernel-owner+w=401wt.eu-S1763429AbZEHKDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763429AbZEHKDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 06:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763269AbZEHKDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 06:03:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42780 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762934AbZEHKDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 06:03:33 -0400
Date: Fri, 8 May 2009 11:03:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rocket tty BUG in 2.6.29 (regression)
Message-ID: <20090508110316.0116208b@lxorguk.ukuu.org.uk>
In-Reply-To: <8763gcsa5e.fsf@tac.ki.iif.hu>
References: <8763gcsa5e.fsf@tac.ki.iif.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 May 2009 02:36:45 +0200
Ferenc Wagner <wferi@niif.hu> wrote:

> Hi,
> 
> 2.6.26 works fine in our terminal server machine, but after rebooting
> it into 2.6.29 I got the following Oops when starting screen for a
> ttyR serial device (after unloading and reloading the rocket module
> while trying to get some udev rename rules right):

So it works the first time around, then blos up the second ? Is this
repeatable ?

In theory Ted is the maintainer for rocket but as I'm the one who last
did any surgery on it this one may well be my bug.

Alan
