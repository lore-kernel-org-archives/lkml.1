Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZERQOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZERQOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbZERQMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:12:37 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33258 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756851AbZERQMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:12:33 -0400
X-Sasl-enc: 6UhhZe0Kil+iknpryaY57zJhmAxV9LISZSiWB48Qnjst 1242663153
Date: Mon, 18 May 2009 13:12:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrea <andrea256it@yahoo.it>, linux-kernel@vger.kernel.org
Subject: Re: super root shell/mode/api
Message-ID: <20090518161231.GC20244@khazad-dum.debian.net>
References: <861928.62033.qm@web23602.mail.ird.yahoo.com> <20090518103545.6603b08e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518103545.6603b08e@lxorguk.ukuu.org.uk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009, Alan Cox wrote:
> Your distribution failed to configure your system sensibly in that case.
> Linux has supported a strict overcommit mode for some years, and in that
> mode a process isn't permitted to drive the system so far out of memory
> it locks up or hangs.

Err... strict overcommit is vm.overcommit_memory=2, right?  That means no
overcommit at all (as far as the documentation goes, anyway).

Which distros enable that by default?

> You can also set some limits on a given process (which with certain
> versions of firefox - especially old ones or if you have the flash plugin
> is a good idea).

Indeed.  Or just limit the users, so that root always has room to work.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
