Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbXHWFwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbXHWFwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 01:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXHWFws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 01:52:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44312 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbXHWFwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 01:52:47 -0400
Date: Thu, 23 Aug 2007 07:52:46 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Richard Ballantyne <richardballantyne@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: file system for solid state disks
In-Reply-To: <46CD14A6.4050605@gmail.com>
Message-ID: <Pine.LNX.4.64.0708230746140.12788@fbirervta.pbzchgretzou.qr>
References: <46CD14A6.4050605@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 23 2007 01:01, Richard Ballantyne wrote:
>
>What file system that is already in the linux kernel do people recommend
>I use for my laptop that now contains a solid state disk?

If I had to choose, the list of options seems to be:

- logfs
  [unmerged]

- UBI layer with any fs you like
  [just a guess]

- UDF in Spared Flavor (mkudffs --media-type=cdrw --utf8)
  [does not support ACLs/quotas]



	Jan
-- 
