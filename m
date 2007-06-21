Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbXFURV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbXFURV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbXFURVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:21:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35890 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXFURVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:21:16 -0400
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
From: Arjan van de Ven <arjan@infradead.org>
To: Alexander Wuerstlein <arw@arw.name>
Cc: linux-kernel@vger.kernel.org,
       Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
In-Reply-To: <11824417551424-git-send-email-arw@arw.name>
References: 20070621155516.GA6838@faui01.informatik.uni-erlangen.de  <11824417551424-git-send-email-arw@arw.name>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 21 Jun 2007 10:17:31 -0700
Message-Id: <1182446251.2704.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 18:02 +0200, Alexander Wuerstlein wrote:
> Modified task_struct to hold a 'signed flag' which is set on exec(), inherited
> on fork() and checked during exec before giving the new process suid/sgid
> privileges.
> 



do you also check the signature of glibc and every other shared library
that the app uses (or dlopens)? if not.. the entire exercise is rather
pointless...

