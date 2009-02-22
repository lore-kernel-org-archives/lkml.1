Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZBVVTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZBVVTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZBVVTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:19:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:52270 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbZBVVTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:19:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=KxQUG+1Kt9IidOSo8ZTASuMs4D7XVNv+CgVx+YHPcqUM0pJyVT+bqoB2GDvv6efXPx
         fK4OP3/ss94yNuoAThXfbYsqkJWZtyKowbszzLrSZPDPHy8lCGXwrZdoYGysswTZENcO
         vN1O1mO9LbBauyaau9Td6hvzn30VpMVMi/6uA=
Date: Sun, 22 Feb 2009 22:12:11 +0100 (CET)
From: Horst Reiterer <horst.reiterer@gmail.com>
X-X-Sender: horstreiterer@horst-reiterers-macbook-air.local
To: Steve French <smfrench@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: Re: [PATCH] fs/cifs: send SMB_COM_FLUSH in cifs_fsync
In-Reply-To: <524f69650902221303h37feb366k3d89a07bfd100ea3@mail.gmail.com>
Message-ID: <alpine.OSX.2.00.0902222206360.7676@horst-reiterers-macbook-air.local>
References: <alpine.OSX.2.00.0902202138421.3998@horst-reiterers-macbook-air.local> <524f69650902201721l1c7f0d34p4708980a90d7fc8f@mail.gmail.com> <alpine.OSX.2.00.0902222137080.7676@horst-reiterers-macbook-air.local>
 <524f69650902221303h37feb366k3d89a07bfd100ea3@mail.gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009, Steve French wrote:
> Suggestions on what to call such a new mount option?  How about
> "nostrictfsync"  ?

Sound good, should be self-explanatory for Samba users and those familiar
with the fsync concept.

Horst.
