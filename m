Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZIWU6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZIWU6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 16:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZIWU6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 16:58:33 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:40324 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZIWU6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 16:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=eEa7Zyrbi9vRJT42K8Pnz6I/EG0DhtuOks4ecFSLku29TtNHSd4fOk894g7FVp5axA
         ASDkZX6hZd21utZ1F/g96UK0iKvdDy5Af2Z/3rxenVapmtSB5ou6pDFO7rF9PijYrHSc
         gEnBZ/pdfQWF5TClrww/RGa8VCIztHbEZPodo=
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 21:58:35 +0100
Message-ID: <5a44caba0909231358y23f21c0drb2a3451084028a6f@mail.gmail.com>
Subject: PATCH 0/1: rt2x00dev.c / rt2x00lib.h fixes build breakage
From: Ken Lewis <kennylewis@gmail.com>
To: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The headers in drivers/net/wireless/rt2x00/rt2x00lib.h don't match the
use of the function in rt2x00dev.c  The build fails as a result.

This has been a problem in linux-next since early September.  I've
e-mailed a patch to linux-next and to linux-net, but the 2.6.32 merge
window has brought the problem to the mainline and so I'm re-sending
my patch.  I've opened a bug on bugzilla:
http://bugzilla.kernel.org/show_bug.cgi?id=14217

Take care.
Ken
