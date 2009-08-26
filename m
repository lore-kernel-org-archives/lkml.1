Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbZHZCxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbZHZCxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 22:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbZHZCxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 22:53:54 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41314 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756456AbZHZCxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 22:53:52 -0400
X-Sasl-enc: XjkvG5V/eIU1SelSGrSGSc1OSlvqYWREXTC2Ag9E7hjX 1251255234
Date: Tue, 25 Aug 2009 23:53:52 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
       Pavel Machek <pavel@ucw.cz>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Message-ID: <20090826025352.GD14047@khazad-dum.debian.net>
References: <4A9468E8.607@redhat.com>
 <20090825225114.GE4300@elf.ucw.cz>
 <4A946DD1.8090906@redhat.com>
 <20090825232601.GF4300@elf.ucw.cz>
 <4A947682.2010204@redhat.com>
 <20090825235359.GJ4300@elf.ucw.cz>
 <4A947DA9.2080906@redhat.com>
 <20090826001645.GN4300@elf.ucw.cz>
 <4A948259.40007@redhat.com>
 <20090826010018.GA17684@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826010018.GA17684@mit.edu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, Theodore Tso wrote:
> a UPS to your system.  Provision your RAID array with hot spares, and
> regularly scrub (read-test) your array so that failed drives can be

Can we get a proper scrub function (full rewrite of all component
disks), please?  Not every disk out there will stop a streaming read to
rewrite weak sectors it happens to come across.

> detected early.  Make sure you configure your MD setup so that you get
> e-mail when a hard drive fails and the array starts running in
> degraded mode, so you can replace the failed drive ASAP.

Debian got this right :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
