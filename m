Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZA1Qqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZA1Qqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZA1Qq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:46:27 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:37639 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbZA1Qq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:46:26 -0500
Date: Wed, 28 Jan 2009 11:42:36 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] migration: migrate_vmas should check "vma"
In-Reply-To: <20090128162619.2205befd.nishimura@mxp.nes.nec.co.jp>
Message-ID: <alpine.DEB.1.10.0901281140540.7765@qirst.com>
References: <20090128162619.2205befd.nishimura@mxp.nes.nec.co.jp>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Daisuke Nishimura wrote:

> migrate_vmas() should check "vma" not "vma->vm_next" for for-loop condition.

The loop condition is checked before vma = vma->vm_next. So the last
iteration of the loop will now be run with vma = NULL?
