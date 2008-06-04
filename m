Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbYFDIBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbYFDIBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbYFDIBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:01:06 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:30148 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYFDIBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:01:05 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 1/3] hvc_console: rework setup to replace irq functions with callbacks (not word wrapped)
Date: Wed, 4 Jun 2008 10:00:16 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
References: <200806031444.21945.borntraeger@de.ibm.com> <200806031449.14385.borntraeger@de.ibm.com> <200806031930.09556.arnd@arndb.de>
In-Reply-To: <200806031930.09556.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041000.16291.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juni 2008 schrieb Arnd Bergmann:
> I don't see a reason to make this data structure known to other files,
> so why not leave it in hvc_console.c?

Yes, Fixed. I moved it for a ealier version of this patch. Currently its not 
necessary. Dont know if I need to move it again if I work on Rusty's ideas.

Christian
