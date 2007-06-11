Return-Path: <linux-kernel-owner+w=401wt.eu-S1764534AbXFKKOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764534AbXFKKOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 06:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758301AbXFKKOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 06:14:15 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42796 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbXFKKON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 06:14:13 -0400
Message-ID: <466D2070.9020306@fr.ibm.com>
Date: Mon, 11 Jun 2007 12:14:08 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Kirill Korotaev <dev@sw.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH -mm 2/2] user namespace : add unshare
References: <46697244.7000900@fr.ibm.com> <20070608121627.f7d97cc4.akpm@linux-foundation.org>
In-Reply-To: <20070608121627.f7d97cc4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 08 Jun 2007 17:14:12 +0200
> Cedric Le Goater <clg@fr.ibm.com> wrote:
> 
>> Changelog: Fix !CONFIG_USER_NS clone with CLONE_NEWUSER so it returns -EINVAL
>> 	rather than 0, so that userspace knows they didn't get a new user
>> 	namespace.
> 
> This changelog doesn't seem to match this patch.

Indeed. the changelog entry is now deprecated since I removed 
CONFIG_USER_NS. 

that was a fix for the issue you reported about that patch breaking 
the mouse under FC5 when the kernel was compiled without CONFIG_USER_NS. 

C.
