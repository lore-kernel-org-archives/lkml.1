Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679Ab0ANUxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0ANUxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043Ab0ANUxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:53:08 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40353 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956Ab0ANUxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:53:07 -0500
X-Sasl-enc: yWAE8UBwp9+U/cxAUP97pKQ3fW56zF3+4f1JlUS3EbvP 1263502386
Date: Thu, 14 Jan 2010 18:53:04 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - reset inode permissions before
 unlinking
Message-ID: <20100114205304.GC3814@khazad-dum.debian.net>
References: <1263388596.26006.1.camel@yio.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263388596.26006.1.camel@yio.site>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010, Kay Sievers wrote:
> across the device lifetime by creating hardlinks, in the unusual case
> that there is a user-writable directory on the same filesystem.

Does a tmpfs mounted in /dev/shm count as "user-writable directory on the
same filesystem" ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
