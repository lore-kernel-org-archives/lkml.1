Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbZHUTHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbZHUTHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZHUTHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:07:41 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56328 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZHUTHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:07:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=TfEK7tGDBo+HjKod7jhpzhNFtU5FxlBzDB5fGAJodKEoGv/aCsYRrpMTIomhQRLw8t
         DokT/jBqg8y1ceEljL+Pj4ZvHssFE2RELIxZYspEDHtU7wtKA98L9eOKbFhG4zgSwzg6
         1EykNS4MPd9Q9kRJJkhBQ2C+venrHYW1F5tPE=
MIME-Version: 1.0
Date: Fri, 21 Aug 2009 21:07:41 +0200
Message-ID: <b637ec0b0908211207raaf1cdqdde9ad5f49fc1f8c@mail.gmail.com>
Subject: Bug: i915 3D performance degradation after suspend-to-ram
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
With Linux 2.6.31-rc6-git7 I see some 50% 3D performance degradation
after a suspend-to-ram cycle. I normally use only two 3D apps:
glxgears falls from 591 FPS to 400 FPS and stellarium from 19/20 FPS
to 12/13 FPS.

The hardware is an eeePC 900 (915GM) and userspace is updated (xserver
is 1.6.3 and the intel driver is from git tree).

I don't think this is a regression.
Regards,
Fabio
