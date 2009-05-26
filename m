Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZEZMuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZEZMuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZEZMuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:50:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36905 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZEZMuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:50:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090526115953.GA4958@x200.localdomain>
References: <20090526115953.GA4958@x200.localdomain>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] Remove cred leftovers from sched.h
Date: Tue, 26 May 2009 13:50:05 +0100
Message-ID: <25824.1243342205@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> wrote:

> struct user_struct and functions which work with it do not belong to sched.h

Is it also worth extracting the user and capabilities management stuff from
kernel/ and sticking it in security/ so that all the security related stuff is
in one place?  Not necessarily in this patch, though...

David
