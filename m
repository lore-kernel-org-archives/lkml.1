Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZILFol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZILFol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 01:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZILFok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 01:44:40 -0400
Received: from waste.org ([173.11.57.241]:33839 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbZILFok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 01:44:40 -0400
Subject: Re: [PATCH] logo: random logo selection option
From: Matt Mackall <mpm@selenic.com>
To: Miguel Boton <waninkoko@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200909120103.41128.mboton@gmail.com>
References: <200909120103.41128.mboton@gmail.com>
Content-Type: text/plain
Date: Sat, 12 Sep 2009 00:44:32 -0500
Message-Id: <1252734272.31016.94.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 01:03 +0200, Miguel Boton wrote:
> If we select more than one logo in the kernel configuration, only the 'latest' one gets
> displayed. Because of this the other logos do not ever have a chance to be displayed.
> 
> This patch adds a selectable option to display a random logo during the bootup process.
> This way the kernel will be able to display any available logo, making the bootup process
> a little different every time ;)

[I foolishly read every LKML message with 'random' in the title..]

Bonus points if you add printing a fortune from a compiled-in fortune
database? Let's not do this, please. Our goal is instead to boot so fast
that such things aren't visible.

-- 
http://selenic.com : development and support for Mercurial and Linux


