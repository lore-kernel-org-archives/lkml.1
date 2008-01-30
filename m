Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbYA3TFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbYA3TFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYA3TFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:05:03 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52151 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYA3TFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:05:01 -0500
Date: Wed, 30 Jan 2008 20:05:00 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Steve French <smfrench@gmail.com>
cc: Adrian Bunk <bunk@kernel.org>, sfrench@samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove smbfs
In-Reply-To: <524f69650801301053s370c9a2fpd03bf31616e37d9c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801302003560.13036@fbirervta.pbzchgretzou.qr>
References: <20080128220835.GF8767@does.not.exist> 
 <Pine.LNX.4.64.0801301923450.13036@fbirervta.pbzchgretzou.qr>
 <524f69650801301053s370c9a2fpd03bf31616e37d9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2008 12:53, Steve French wrote:
>I have mounted to Windows98 a few months ago with no problems (other
>than a few restrictions like you can't set the file times via utimes).
> For mounts to Windows98 note that you have to specify the server
>netbios name on the mount (since it is not the same as the DNS name).
>In your example your would need to specify "servernetbiosname=WIN98"
>in the mount options (until mount.cifs autoretries with
>servernetbiosname assumed to be the beginning of the UNC name - note
>that later servers have a dummy netbios name that is used so this
>mount option is only needed for OS/2 and Win9x).

Ok that works. I had tried "netbiosname" but not "servernetbiosname"
(only fuzzy memories from the last win98 encounter and the suggestion
to use netbiossomething).

I think servernetbiosname should implicitly be assumed to be the
same as the //hostpart/ when it's not explicitly specified, no?
