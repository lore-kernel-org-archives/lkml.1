Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYL2Aya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYL2Aya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYL2AyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:54:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbYL2AyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:54:20 -0500
Date: Sun, 28 Dec 2008 16:53:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT] Security changes for 2.6.29
In-Reply-To: <7921.1230511311@redhat.com>
Message-ID: <alpine.LFD.2.00.0812281651480.3082@localhost.localdomain>
References: <alpine.LFD.2.00.0812281232350.3057@localhost.localdomain> <alpine.LRH.1.10.0812251158550.27893@tundra.namei.org> <7921.1230511311@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Dec 2008, David Howells wrote:
> 
> Does this fix the warning?  My compiler doesn't show it; of course, I'm not
> using gcc-4.3.2, but something older.

Yup, this seems to fix it for me in my quick test. It seems that not 
initializing the pointer for the error case makes gcc unhappy.

		Linus
