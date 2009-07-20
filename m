Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbZGTO73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbZGTO73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZGTO72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:59:28 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42739 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbZGTO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:59:27 -0400
X-Sasl-enc: XYaQ1MkwRGQd5vyzzNWeWQWuEm+1Qo7qJxY9kGF6T7I+ 1248101967
Date: Mon, 20 Jul 2009 11:59:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/10] drivers/gpu/drm: Move a dereference below a NULL
 test
Message-ID: <20090720145924.GA21724@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0907191725290.16542@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907191725290.16542@ask.diku.dk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AFAIK, all of those "move derreference below NULL test" count as potential
security fixes.  If the patches get accepted, please consider sending them
to -stable as well, or asking the maintaiers to do so...

Also, can we teach that deference-before-NULL-test pattern to sparse, or
some other tool that will periodically warn us when such problematic
patterns show up again in the tree?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
