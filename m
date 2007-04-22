Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbXDVSqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbXDVSqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXDVSqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:46:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57345 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbXDVSqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:46:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/3] Suspend notifiers
Date: Sun, 22 Apr 2007 20:10:21 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704222010.21999.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The last two patches from this series are intended to address the problem that
some drivers allocate a lot of memory in their .suspend() routines causing
swsusp to fail (and generally may want to do some things that shouldn't be
done in .suspend()/.resume()).

The first one is a fix.

Greetings,
Rafael

