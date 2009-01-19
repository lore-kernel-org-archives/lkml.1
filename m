Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbZASBWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbZASBWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 20:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZASBWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 20:22:45 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:49977 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbZASBWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 20:22:44 -0500
Date: Mon, 19 Jan 2009 02:24:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: install to a single directory
Message-ID: <20090119012428.GB4491@uranus.ravnborg.org>
References: <alpine.LSU.2.00.0901172055100.15992@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0901172055100.15992@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 10:17:16PM +0100, Jan Engelhardt wrote:
> Hi,
> 
> 
> 
> This proposed change will collect all kernel modules in the
> single directory, e.g. /lib/modules/2.6.29-rc2/kernel/, without
> any further directory structure. About 475 inodes (with
> almost-allmodconfig) less are used, which should result
> in faster directory traversal (less seeks).

Hi Jan.

Can you elaborate a little more why this is needed / a good thing.

Also:
-> Is mod-utils compatible with this change
-> Is userland in general compatible with this change

	Sam
