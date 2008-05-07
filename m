Return-Path: <linux-kernel-owner+w=401wt.eu-S1765066AbYEGTtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765066AbYEGTtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYEGTte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:49:34 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:61875 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYEGTtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:49:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=se3LLKO2zH5A2Xy+jjA+watCAssWnCAE9s3Q+0RZGACGF2hdH8wesq7+shGfcumhy8m1OG2Ux/UzmOyhXhHEaRWfWywZwaJxcK57QC1La2tyskh8+xbbUYFyg5pQ75IhGU6JDALEOngiToaAKOHZTEfZSbVgjyUltNym4NCXcWY=
Message-ID: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
Date: Wed, 7 May 2008 15:49:30 -0400
From: "Morten Welinder" <mwelinder@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Deleting large files
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

deleting large files, say on the order of 4.6GB, takes approximately forever.
Why is that?  Well, it is because a lot of things need to take place to free
the formerly used space, but my real question is "why does the unlink caller
have to wait for it?"

I.e., could unlink do the directory changes and then hand off the rest of the
task to a kernel thread?

Morten
