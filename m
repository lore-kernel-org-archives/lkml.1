Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbZKLCMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbZKLCMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759909AbZKLCMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:12:09 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58930 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759904AbZKLCMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:12:08 -0500
X-Sasl-enc: PR8C3eG2tCTlnJ4P5c+9jPO/cFA+IyBJ7/Hr5S0F2Paw 1257991933
Date: Thu, 12 Nov 2009 00:12:09 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
Message-ID: <20091112021209.GA21625@khazad-dum.debian.net>
References: <4AFACC03.7080209@mayc.ru>
 <4AFB2822.30906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFB2822.30906@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009, Robert Hancock wrote:
> I don't think that we prevent any access to device registers in
> /dev/mem - if you read something that has side effects and something
> breaks, well I guess you get to keep both pieces :-) There's a
> reason it's root-only..

We should.  Imaging /dev/mem is one of the oldest tricks in the book of the
forensics people, they do it to live systems to help track down WTF happened
to a compromised host.  This kind of crap bites them hard.

IMO: if you're going to provide /dev/mem, make it as safe as possible.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
