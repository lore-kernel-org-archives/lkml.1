Return-Path: <linux-kernel-owner+w=401wt.eu-S1764940AbYARU2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764940AbYARU2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761558AbYARU2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:28:15 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55509 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761187AbYARU2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:28:14 -0500
Date: Fri, 18 Jan 2008 12:26:13 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH 1/10] add missing parameter for lookup_address
Message-ID: <20080118202613.GY3627@sequoia.sous-sol.org>
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12006768362108-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Glauber de Oliveira Costa (gcosta@redhat.com) wrote:
> lookup_address() receives two parameters, but efi_64.c call
> is passing only one. It's actually preventing the tree from compiling
> 
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

Good catch, I know I don't test with CONFIG_EFI=y
