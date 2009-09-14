Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZINLxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZINLxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 07:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZINLxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 07:53:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbZINLxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 07:53:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
References: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       sds@tycho.nsa.gov, jmorris@namei.org, mingo@elte.hu
Subject: Re: [PATCH 1/3] Creds: creds->security can be NULL is selinux is disabled
Date: Mon, 14 Sep 2009 12:53:33 +0100
Message-ID: <11977.1252929213@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> wrote:

> __validate_process_creds should check if selinux is actually enabled before
> running tests on the selinux portion of the credentials struct.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
