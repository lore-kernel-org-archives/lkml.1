Return-Path: <linux-kernel-owner+w=401wt.eu-S1757637AbYAPCal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbYAPCal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYAPCac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:30:32 -0500
Received: from smtpoutm.mac.com ([17.148.16.77]:61435 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbYAPCab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:30:31 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 21:30:31 EST
Cc: sds@tycho.nsa.gov, casey@schaufler-ca.com, Trond.Myklebust@netapp.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Message-Id: <AEF7FD5A-F622-46A1-8034-2FAF10CEBA46@mac.com>
From: Kyle Moffett <mrlinuxman@mac.com>
To: David Howells <dhowells@redhat.com>
In-Reply-To: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 00/26] Permit filesystem local caching
Date: Tue, 15 Jan 2008 21:24:00 -0500
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008, at 18:46, David Howells wrote:
>  (*) 01-keys-inc-payload.diff
>  (*) 02-keys-search-keyring.diff
>  (*) 03-keys-callout-blob.diff

One vaguely related question:  Is there presently any way to adjust  
the per-user max-key-data limit? I've been tinkering with using the  
new-ish MIT kerberos "KEYRING:" credentials-cache code to hold keys  
for persistent daemons.  Unfortunately "root" keeps hitting the limit  
even with only about 16 keys allocated across a few sessions.  After  
perusing the docs I can't find any documentation on adjusting the  
limits.

I'd really like some way to specifically allow root to allocate up to  
several megs worth of non-swappable key data, although I suppose just  
increasing the global limit slightly wouldn't be bad either.  If such  
functionality already exists then I'd appreciate a pointer to it (and  
possibly respond in kind with documentation patches).

Cheers,
Kyle Moffett

