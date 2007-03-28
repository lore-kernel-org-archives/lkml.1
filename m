Return-Path: <linux-kernel-owner+w=401wt.eu-S1751056AbXC1NQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056AbXC1NQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbXC1NQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:16:35 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:55914 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbXC1NQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:16:34 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Stuart MacDonald" <stuartm@connecttech.com>
Subject: Re: question on tty open and close
Date: Wed, 28 Mar 2007 15:16:30 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <019101c7713a$73bfcce0$294b82ce@stuartm>
In-Reply-To: <019101c7713a$73bfcce0$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703281516.31366.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH7LxRcmd0Z
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 28. März 2007 15:10 schrieb Stuart MacDonald:
> > We find that a failure in open() leads to release_dev() being called.
> > release_dev() calls close():
> > 
> >       if (tty->driver->close)
> >               tty->driver->close(tty, filp);
> > 
> > So we have a file that's closed although open() never succeeded?
> 
> That's correct! It's been a pain in my butt for years.

How did you deal with that proctological issue?

	Regards
		Oliver
