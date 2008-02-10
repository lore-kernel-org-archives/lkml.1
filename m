Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYBJMrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYBJMrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbYBJMrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:47:35 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:54391 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbYBJMrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:47:33 -0500
Date: Sun, 10 Feb 2008 13:47:31 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Niki Denev <ndenev@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
Message-ID: <20080210124731.GA25396@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Niki Denev <ndenev@gmail.com>, Willy Tarreau <w@1wt.eu>,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com
References: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com> <20080210063247.GQ8953@1wt.eu> <2e77fc10802092238k13efb111ifcd298daaf7b4aba@mail.gmail.com> <2e77fc10802100140q5c8adfb4k7db88d48cbd5f8b2@mail.gmail.com> <20080210122250.GA24048@wavehammer.waldi.eu.org> <2e77fc10802100439u18e89008j9181f3b445daa231@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2e77fc10802100439u18e89008j9181f3b445daa231@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 12:39:05PM +0000, Niki Denev wrote:
> This patch is against 2.6.24.1 which has already the fix to vmsplice_to_user
> With it i can't exploit the hole, and it is returns "invalid address"

This is the vmsplice_to_pipe path and I have many reports that it is not
fixed.

Bastian

-- 
If there are self-made purgatories, then we all have to live in them.
		-- Spock, "This Side of Paradise", stardate 3417.7
