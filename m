Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYABCoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYABCoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYABCoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:44:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYABCoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:44:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pc/lueK9laCcTpgjoHKw7znTWPO2k2HVkfyZOC6IVlXi420pLBsXQ1ckqGXd0CxQOI1lFO9FnopiOyEJYvZLWZw94wR6FTVkVNDPzvnUHPcjlD1kY6E2WbZC1DGcvVDUkDQmQ/fSPyHy5bQHaiC+rNvwhOj9NyFKoK21FSFImL0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Nuke a few duplicate includes
Date: Wed, 2 Jan 2008 03:39:00 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801020339.00698.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including the same header twice (or more) in a .c file, outside any #ifdef's 
and whatnot,  serves no purpose except generating more work for the 
compiler, so here are 3 patches that get rid of some pointless duplicate 
includes.

Kind regards,
  Jesper Juhl <jesper.juhl@gmail.com>


