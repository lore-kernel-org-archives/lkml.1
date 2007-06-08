Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbXFHTSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbXFHTSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbXFHTRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:17:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38183 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbXFHTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:17:53 -0400
Date: Fri, 8 Jun 2007 12:16:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Kirill Korotaev <dev@sw.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH -mm 2/2] user namespace : add unshare
Message-Id: <20070608121627.f7d97cc4.akpm@linux-foundation.org>
In-Reply-To: <46697244.7000900@fr.ibm.com>
References: <46697244.7000900@fr.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2007 17:14:12 +0200
Cedric Le Goater <clg@fr.ibm.com> wrote:

> Changelog: Fix !CONFIG_USER_NS clone with CLONE_NEWUSER so it returns -EINVAL
> 	rather than 0, so that userspace knows they didn't get a new user
> 	namespace.

This changelog doesn't seem to match this patch.
