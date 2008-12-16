Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbYLPLkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbYLPLkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbYLPLkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:40:16 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:39911 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbYLPLkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:40:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=FgihJStC1Z2l9ea84T5cgeNKPTmgeIX7b0ysMcytcHGWBjAdsR32ZVDX3CGk9cf/Y0
         KoElRpbEP1FpXADKEM2/CLz0D/AdHKYNSbEg7SikJtIKcvjDaZPDRFzEr5DkJO+B263L
         qcdgXwYHZM+RzDgwBAIbRBK/RfrgIwhLaZbtM=
Message-ID: <81bfc67a0812160340u1d0f2441jb3351b58873667cb@mail.gmail.com>
Date: Tue, 16 Dec 2008 06:40:12 -0500
From: "Caleb Cushing" <xenoterracide@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.28-rc8 intel i915 video bug?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

problem is when switching from kwin in opengl mode to a VT then back
to x11, x11 freezes, and I'm forced to hard reset the system.

last part of Xorg.0.log.old

(II) intel(0): EDID vendor "DEL", prod id 41015
exaCopyDirty: Pending damage region empty!
(II) AIGLX: Suspending AIGLX clients for VT switch
(II) intel(0): xf86UnbindGARTMemory: unbind key 0
(II) intel(0): xf86UnbindGARTMemory: unbind key 1

at this point I'm not really sure this is a kernel bug, it could be
anywhere from the kernel to kwin. I do know that I didn't have this
issue in previous kernels (skipped 2.6.27 though). I was thinking
maybe this somehow has something to do with the new GEM system but I
could be off base.

more info available upon request, please cc me as I'm not on the list
-- 
Caleb Cushing

http://xenoterracide.blogspot.com
