Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbYABPlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbYABPlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYABPlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:41:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbYABPlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:41:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Xine.LNX.4.64.0712201506520.6851@us.intercode.com.au>
References: <Xine.LNX.4.64.0712201506520.6851@us.intercode.com.au> <20071219093834.GW4396912@sgi.com> <Xine.LNX.4.64.0712201052110.1736@us.intercode.com.au> <20071220014413.GK4612@sgi.com>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, David Chinner <dgc@sgi.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: [patch, rfc] mm.h, security.h, key.h and preventing namespace poisoning
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 02 Jan 2008 15:41:06 +0000
Message-ID: <32216.1199288466@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> I suspect it may be useful ensure all global identifiers for the key 
> subsystem are prefixed with key_, as 'copy_keys' does seem a little 
> generic.

Many of the fork helpers are called copy_xxx().

David
