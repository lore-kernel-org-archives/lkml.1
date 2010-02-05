Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab0BENsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:48:09 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37030 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab0BENsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:48:06 -0500
In-Reply-To: <1265364881-8140-1-git-send-email-dfeng@redhat.com>
References: <1265364881-8140-1-git-send-email-dfeng@redhat.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, serue@linux.vnet.ibm.com,
       Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Subject: Re: [PATCH] ima: avoid null pointer deref in ima_main.c
X-KeepSent: D4EDD9E8:3C38BC7C-852576C1:004B1271;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OFD4EDD9E8.3C38BC7C-ON852576C1.004B1271-852576C1.004BCFCC@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Fri, 5 Feb 2010 08:48:04 -0500
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5.1HF41 | October 22, 2009) at
 02/05/2010 08:48:04,
	Serialize complete at 02/05/2010 08:48:04
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng <dfeng@redhat.com> wrote on 02/05/2010 05:14:41 AM:

> I've met following oops when kernel is running ltp test pipe07.
> Which is trying to open pipes until EMFILE is returned.

This is a known bug and a patch was posted by J.R Okajima on Dec 29th
http://lkml.org/lkml/2009/12/29/13.

James, Al, can we get the patch applied?

Mimi



