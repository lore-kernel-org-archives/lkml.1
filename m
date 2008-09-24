Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbYIXLrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbYIXLrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYIXLrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:47:10 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33568 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYIXLrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:47:09 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: mlock: Make the mlock system call interruptible by fatal
Date: Wed, 24 Sep 2008 13:49:40 +0200
User-Agent: KMail/1.9.9
Cc: Salman Qazi <sqazi@google.com>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20080923224751.GA2790@google.com> <20080924112255.64304a64@lxorguk.ukuu.org.uk>
In-Reply-To: <20080924112255.64304a64@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241349.42103.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 24. September 2008 12:22:55 schrieb Alan Cox:
> > > Can we do
> > >
> > >        return i ? i : -EINTR;
> > >
> > > in the usual fashion?
> > 
> > Fixed.
> 
> If its only interruptible by fatal signals why do we care what the return
> is ?

ptrace?

	Regards
		Oliver


