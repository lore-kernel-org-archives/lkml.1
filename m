Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbZIMWYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbZIMWYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 18:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZIMWYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 18:24:14 -0400
Received: from tundra.namei.org ([65.99.196.166]:53062 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZIMWYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 18:24:13 -0400
Date: Mon, 14 Sep 2009 08:23:53 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, sds@tycho.nsa.gov,
       mingo@elte.hu, dhowells@redhat.com
Subject: Re: [PATCH 1/3] Creds: creds->security can be NULL is selinux is
 disabled
In-Reply-To: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0909140823320.27953@tundra.namei.org>
References: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Sep 2009, Eric Paris wrote:

> __validate_process_creds should check if selinux is actually enabled before
> running tests on the selinux portion of the credentials struct.

Have you verified that this fixes the problem?


-- 
James Morris
<jmorris@namei.org>
