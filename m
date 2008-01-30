Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbYA3S2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbYA3S2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYA3S17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:27:59 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56637 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYA3S17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:27:59 -0500
Date: Wed, 30 Jan 2008 19:27:57 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Adrian Bunk <bunk@kernel.org>
cc: sfrench@samba.org, samba-technical@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove smbfs
In-Reply-To: <20080128220835.GF8767@does.not.exist>
Message-ID: <Pine.LNX.4.64.0801301923450.13036@fbirervta.pbzchgretzou.qr>
References: <20080128220835.GF8767@does.not.exist>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 29 2008 00:08, Adrian Bunk wrote:
>
>I remember that there were some small things missing in CIFS for 
>completely replacing the unmaintained smbfs when we discussed removing 
>smbfs back in 2005 due to smbfs being unmaintained.
>
>CIFS has improved since, smbfs is still unmaintained, and it's becoming 
>time to finally remove smbfs.

Negative. CIFS as of 2.6.24-rc7 still does not support Windows 98,
or at least, the mount command I tried was not the right one:

	mount -t cifs //WIN98/c /mnt -o guest,sec=none

(It is a test share with a null password open for anyone.) I am running
out of options..

	CIFS VFS: cifs_mount failed w/return code = -2
