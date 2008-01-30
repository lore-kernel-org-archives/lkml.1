Return-Path: <linux-kernel-owner+w=401wt.eu-S933718AbYA3VVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbYA3VVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbYA3VRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:17:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:50215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744AbYA3VRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:17:04 -0500
From: Guenter Kukkukk <linux@kukkukk.com>
Organization: EfM
To: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove smbfs
Date: Wed, 30 Jan 2008 22:16:13 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
References: <20080128220835.GF8767@does.not.exist>
In-Reply-To: <20080128220835.GF8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801302216.13788.linux@kukkukk.com>
X-Provags-ID: V01U2FsdGVkX19RmD6z3wQkZhMyQ/vnp1yaTYeWz+CpL4OROc+
 8RPZUE478nB0Va+h8j4ZInYhrVMLXYwCPJmEcV/2X5eOolplbv
 aYCssPlBzh8KpYOjcFL+iFrqxSktt7m
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 28. Januar 2008 schrieb Adrian Bunk:
> I remember that there were some small things missing in CIFS for 
> completely replacing the unmaintained smbfs when we discussed removing 
> smbfs back in 2005 due to smbfs being unmaintained.
> 
> CIFS has improved since, smbfs is still unmaintained, and it's becoming 
> time to finally remove smbfs.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

"... unmaintained smbfs ..." is not quite right, see
   http://lkml.org/lkml/2007/11/6/94
Before removing it now completely, drop
  Jeff Layton <jlayton@redhat.com>
a note.
Afaik, Redhat still has customers which rely on smbfs.

In addition, cifs cannot completely replace smbfs atm.
Even todays sold NAS-boxes (often running anchient 
samba-2.x.x) work only with smbfs on the client side.
Cheers, Günter 

