Return-Path: <linux-kernel-owner+w=401wt.eu-S1762364AbXJRUMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762364AbXJRUMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXJRUMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:12:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59503 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbXJRUMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:12:14 -0400
Date: Thu, 18 Oct 2007 22:12:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: jaroslav.sykora@gmail.com
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Shadow directories
In-Reply-To: <200710182210.17910.jara@sin.cvut.cz>
Message-ID: <Pine.LNX.4.64.0710182211550.22233@fbirervta.pbzchgretzou.qr>
References: <200710181721.09201.jara@sin.cvut.cz> <200710181907.58643.jara@sin.cvut.cz>
 <Pine.LNX.4.64.0710181908240.22233@fbirervta.pbzchgretzou.qr>
 <200710182210.17910.jara@sin.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 18 2007 22:10, Jaroslav Sykora wrote:
>
>A minor implementation problem with chrooted environment is that the
>FUSE VFS server must be run with root privileges to allow setuid
>programs on the mounted filesystems. But it's certainly doable.

You would not want user-supplied filesystems to carry SUID bits...
