Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYEYPMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYEYPMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 11:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYEYPMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 11:12:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:19278 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbYEYPMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 11:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WLdaYDZgTOzJpy6F8CMIXtp1bRCmHxwJQ9HpjhRX6Z5jLyvmziVCCR5xbeNYWnPisOdx6dJGFccRgWQvgu6gAsssp9mZoFVDUPb9LRsd9o5pYLLvb/jtNQjgKP+05svdD10u9Ob5GXLIHjqpMpHZJokzxAp3OPPWtZHeM8+UN+4=
Message-ID: <38b2ab8a0805250812l2ecd424bh74a1694ed56460de@mail.gmail.com>
Date: Sun, 25 May 2008 17:12:06 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: question about splice performance
Cc: jens.axboe@oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I did a really basic benchmark and was suprise about the results.

$ echo 3 > /proc/sys/vm/drop_caches
$ time  splice-cp  vmlinux /tmp/vmlinux

real    0m10.158s
user    0m0.002s
sys     0m0.401s

$ echo 3 > /proc/sys/vm/drop_caches
$ time  cp  vmlinux /tmp/vmlinux

real    0m10.590s
user    0m0.017s
sys     0m0.459s


I was expecting splice-cp case to be faster.

Could someone enlight me ?

Thanks
-- 
Francis
