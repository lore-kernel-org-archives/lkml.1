Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbZJNMii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbZJNMii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZJNMih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:38:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42769 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751749AbZJNMih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:38:37 -0400
Date: Wed, 14 Oct 2009 13:38:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       "Alexandros C. Couloumbis" <alex@ozo.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] pata_sc1200: Fix crash on boot
Message-ID: <20091014133806.63804e19@lxorguk.ukuu.org.uk>
In-Reply-To: <20091013185637.870369c8.akpm@linux-foundation.org>
References: <20091006150737.9610.81541.stgit@localhost.localdomain>
	<20091013185637.870369c8.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch applies to 2.6.31 and 2.6.30 (at least).  How far back
> should it be ported?

Having had a dig the bug was introduced in
c0f2ee34a5a0b79fd98d965ad8ae765d4639bfa5

I've not however tested the patch with any older releases.

Alan
