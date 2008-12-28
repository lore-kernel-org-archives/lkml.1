Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbYL1UeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbYL1UeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 15:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbYL1Udz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 15:33:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbYL1Udy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 15:33:54 -0500
Date: Sun, 28 Dec 2008 12:32:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Morris <jmorris@namei.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT] Security changes for 2.6.29
In-Reply-To: <alpine.LRH.1.10.0812251158550.27893@tundra.namei.org>
Message-ID: <alpine.LFD.2.00.0812281232350.3057@localhost.localdomain>
References: <alpine.LRH.1.10.0812251158550.27893@tundra.namei.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Dec 2008, James Morris wrote:
>
> Please pull the following security changes for 2.6.29.

Grrr..

  security/keys/keyctl.c: In function ¡keyctl_negate_key¢:
  security/keys/keyctl.c:976: warning: ¡dest_keyring¢ may be used uninitialized in this function
  security/keys/keyctl.c: In function ¡keyctl_instantiate_key¢:
  security/keys/keyctl.c:898: warning: ¡dest_keyring¢ may be used uninitialized in this function

My nice warning-less build is no longer warning-less. 

Yes, it's possible that this is just a bogus warning, with gcc-4.3.2 for
x86-64, but please fix it.

		Linus
