Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbZAHJjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbZAHJjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZAHJjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:39:04 -0500
Received: from ext-cn0ut-6.online-age.net ([63.210.253.235]:30797 "EHLO
	ext-cn0ut-6.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212AbZAHJjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:39:00 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 04:39:00 EST
Date: Thu, 8 Jan 2009 10:33:05 +0100
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Inconsistent disk state when creating paritions
Message-ID: <20090108093305.GA10952@kipc2.localdomain>
References: <Pine.LNX.4.61.0901071715070.9551@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0901071715070.9551@chaos.analogic.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-GEHealthcare-MailScanner: Found to be clean
X-GEHealthcare-MailScanner-From: karl.kiniger@med.ge.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 090107, linux-os (Dick Johnson) wrote:
> Attempting to use mkfs immediately after creating
> partitions using sfdisk, (in the same shell-script)
> fails with all kernels I have tried. The partition
> information doesn't get updated for several seconds!

are you using udev?

udev takes some time to create the partition devices

Karl

> 
> In every case, with both ext2 and ext3 file-systems,
> I can create them manually or I can sleep in the
> shell-script. However, I don't think this problem
> should exist.
-- 
Karl Kiniger     mailto:karl.kiniger@med.ge.com
Tel: (++43) 7682-3800-710  Voip(GE): 1662 710
Fax: (++43) 7682-3800-47 C: +43 6991 3800 710
-
GE Medical Systems Kretztechnik GmbH & Co OHG - Tiefenbach 15 – A-4871 Zipf
Landesgericht Wels FN 222387s – UID (VAT-ID): ATU54086108 - DVR: 2111103 – ARA: 12816
Persönlich haftende Gesellschafterin: GE Medical Systems Kretztechnik GmbH
Tiefenbach 15 – A-4871 Zipf  - Landesgericht Wels FN 218689b
