Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZGUDrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZGUDrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 23:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZGUDrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 23:47:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:55611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbZGUDrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 23:47:31 -0400
Date: Mon, 20 Jul 2009 20:48:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jmorris@namei.org,
       spender@grsecurity.net, dwalsh@redhat.com, cl@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
Message-ID: <20090720204848.5f37c92a@infradead.org>
In-Reply-To: <1248132223.2654.278.camel@localhost>
References: <1248132223.2654.278.camel@localhost>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 19:23:43 -0400
Eric Paris <eparis@redhat.com> wrote:
> 
> Does anyone see a better way to let users continue to be users while
> protecting most people?  Yes SELinux is stronger in some areas than
> without confining the ability to map the 0 page, but as has be rightly
> pointed out it's foolish an broken that SELinux can weaken any
> protections.

one option is to allow the page to be mapped, but only as
non-executable... in DOS that memory isn't where code lives anyway...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
