Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZETGDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZETGDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 02:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZETGDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 02:03:40 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:49048 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZETGDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 02:03:40 -0400
Date: Wed, 20 May 2009 07:03:27 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrea <andrea256it@yahoo.it>,
       linux-kernel@vger.kernel.org
Subject: Re: super root shell/mode/api
Message-ID: <20090520060327.GB31552@sucs.org>
References: <861928.62033.qm@web23602.mail.ird.yahoo.com> <20090518103545.6603b08e@lxorguk.ukuu.org.uk> <20090518161231.GC20244@khazad-dum.debian.net> <20090520043603.GA9725@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520043603.GA9725@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 06:36:04AM +0200, Willy Tarreau wrote:
> 
> I don't know if mainline distros do this, but some distros dedicated to
> embedded systems have been using that for ages, almost since Alan published
> his first overcommit patch a long time ago. It's the only way to reach
> very long uptimes on servers, as it also protects you against your own
> mistakes (eg: stupid actions such as "vi access.log" when the file is
> larger than memory).

Shouldn't the vi case be taken care of by good ulimits? Certainly that's
what I've seen openSUSE do by default (although strangely SLES 10
doesn't)...

The last I heard about overcommit was that there were always some
legitimate programs that could run that would be stopped by having it on
(evolution always seemed to be mentioned for some reason). As such it
would be surprising to see any of the desktop distros enabling it by
default.

I've been wondering for a while with my EeePC if strict overcommit is a
no brainer if you are running without swap... In such systems the only
things that can be forced out of RAM are mmap'd files (?) so does
overcommit even happen?

-- 
Sitsofe | http://sucs.org/~sits/
