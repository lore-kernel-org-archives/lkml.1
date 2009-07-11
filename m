Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZGKPCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZGKPCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 11:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZGKPC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 11:02:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:17780 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZGKPC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 11:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=W+dBovjdX5bLx+DGxo4AFDOhNdmgFjzy/mvNVCtyDBAwvcEdNAdgFaRpgCGX1PZpxS
         IMWFjKqAkoq55HosXhncQhv2ud9PwZyhAYWhze2WvxDfalxEkOfp5S99356eTN9Z1aWH
         w3zYVtR9mt5ms04WewJzir0wNIk1YI70svsSQ=
Date: Sat, 11 Jul 2009 11:02:20 -0400
From: Ben Gamari <bgamari.foss@gmail.com>
To: xorg@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: SIGQUIT from tty layer
Message-ID: <20090711150220.GB21222@ben-laptop>
Mail-Followup-To: xorg@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090709143141.GA17551@ben-laptop>
 <20090709150047.GE5328@const.famille.thibault.fr>
 <20090709171816.GA6046@ben-laptop>
 <20090710183346.GA7699@const.famille.thibault.fr>
 <20090711111659.GD31623@platonas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090711111659.GD31623@platonas>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 11, 2009 at 02:16:59PM +0300, Marius Gedminas wrote:
> This sounds familiar:
> 
>   "a set of 'stty' calls in the init scripts, that (amazingly) reset the
>    isig flag on the current vt (which in our case is the X vt). For
>    anyone ignorant of the vile mess of consequences that means
>    (obviously) your X server gets a SIGQUIT when you press enter."
>         -- http://www.gnome.org/~michael/blog/2009-05-29.html

Indeed it does. Unfortunately, it doesn't seem like my init scripts have
anything resetting isig. I do have a onlcr reset it seems, but would
that cause a SIGQUIT?

[1101 ben@ben-laptop etc] $ sudo grep stty -R *
init.d/rc:stty onlcr 0>&1
readahead/boot:/bin/stty

Thanks again,

- Ben

