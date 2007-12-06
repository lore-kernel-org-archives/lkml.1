Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXLFO5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXLFO5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 09:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXLFO5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 09:57:39 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:37154 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbXLFO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 09:57:39 -0500
Date: Thu, 6 Dec 2007 15:57:38 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jay Cliburn <jacliburn@bellsouth.net>
cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: Allow (O=...) from file
In-Reply-To: <20071204210433.4d7ee66c@osprey.hogchain.net>
Message-ID: <Pine.LNX.4.64.0712061556350.19266@fbirervta.pbzchgretzou.qr>
References: <20071204210433.4d7ee66c@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 4 2007 21:04, Jay Cliburn wrote:
>
>This piece of the top-level Makefile in current git causes an
>out-of-tree driver Makefile to fail.
>
>101 ifdef O
>102   ifeq ("$(origin O)", "command line")
>103     KBUILD_OUTPUT := $(O)
>104   endif
>105 endif

Should not it just use the usual boilerplate?

kdir := /lib/modules/$(shell uname -r)/build
all:
	make -C ${kdir} M=$$PWD

