Return-Path: <linux-kernel-owner+w=401wt.eu-S1762940AbYF0UJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762940AbYF0UJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbYF0UJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:09:36 -0400
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:38390 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759378AbYF0UJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:09:35 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix pci_setup_device()'s sprinting into a const buffer
Date: Fri, 27 Jun 2008 13:09:28 -0700
User-Agent: KMail/1.9.9
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080627122320.29319.14707.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080627122320.29319.14707.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806271309.29266.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 27, 2008 5:23 am David Howells wrote:
> Make pci_setup_device() write the bus ID directly into the allotted
> storage, rather than using pci_name() as the address as that now returns a
> const pointer.
>
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied.  Thanks David.

Jesse
