Return-Path: <linux-kernel-owner+w=401wt.eu-S932393Ab0AFRG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab0AFRG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932373Ab0AFRGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:06:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab0AFRGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:06:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1262797265-26557-1-git-send-email-jslaby@suse.cz>
References: <1262797265-26557-1-git-send-email-jslaby@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: dhowells@redhat.com, jmorris@namei.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 1/1] cred: fix memory leak
Date: Wed, 06 Jan 2010 17:06:43 +0000
Message-ID: <20320.1262797603@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> wrote:

> Stanse found a memory leak in prepare_exec_creds. tgcred is not
> freed/assigned on all paths. Fix that.
> 
> I.e. unifdef tgcred and add kfree(tgcred); as it is initialized to
> NULL already.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: David Howells <dhowells@redhat.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Serge Hallyn <serue@us.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
