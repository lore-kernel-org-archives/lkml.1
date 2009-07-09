Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZGIRS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZGIRS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZGIRSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:18:21 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:51452 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZGIRSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=i5EWbGC2pL/yyaYHqYdrICcR6uTNjjLbUCVKSH89o84SwO1D20z5iT/6CTJegGysPR
         6hLfoEabiIanEhN5ffCF1/mm9T9glwDVLid4I2Z5qHvQRAl1vgvV/Sn6bxZDs2pqDc8l
         yPLCRswLxNsZcWTNMFGYo9rubZncdFbx26nqY=
Date: Thu, 9 Jul 2009 13:18:16 -0400
From: Ben Gamari <bgamari.foss@gmail.com>
To: linux-kernel@vger.kernel.org, xorg@lists.freedesktop.org
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: SIGQUIT from tty layer
Message-ID: <20090709171816.GA6046@ben-laptop>
Mail-Followup-To: linux-kernel@vger.kernel.org, xorg@lists.freedesktop.org,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090709143141.GA17551@ben-laptop>
 <20090709150047.GE5328@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709150047.GE5328@const.famille.thibault.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 05:00:47PM +0200, Samuel Thibault wrote:
> SIGQUIT is sent to the X server if the controling tty of the X server
> (probably its VT) receives the QUIT character (usually control-\, i.e.
> 0x1c)

This, however, would imply that something is sending the character and
this something is certainly not me. Where else might this character come
from? How might I trace who's writing to the tty?

- Ben

