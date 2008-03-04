Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbYCDW0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbYCDW0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 17:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764780AbYCDW0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 17:26:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764205AbYCDWZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:25:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080304184009.GB24301@freya.fugue.com>
References: <20080304184009.GB24301@freya.fugue.com> <20080303173620.GA9243@freya.fugue.com> <5368.1204641163@redhat.com>
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Patch: romfs_lookup always failed in linux-2.6.25-rc3-git3
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 04 Mar 2008 22:25:56 +0000
Message-ID: <9258.1204669556@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam J. Richter <adam@yggdrasil.com> wrote:

> My only question is why you've changed res from int to long, given that
> you've corrected my misguided "P.S.":

Because if you compile for a 64-bit system, you may find extra instructions
emitted, at the very least in ERR_PTR(res) where it turns a 32-bit int into a
64-bit pointer.

David
