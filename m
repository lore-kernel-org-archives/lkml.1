Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121Ab0ASPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0ASPOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697Ab0ASPOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:14:17 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:34666 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753607Ab0ASPOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:14:16 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jan 2010 10:14:16 EST
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/1] thinkpad-acpi: fix link error to include sound arch
MIME-Version: 1.0
Date: Tue, 19 Jan 2010 16:07:24 +0100
From: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: <linux-kernel@vger.kernel.org>
In-Reply-To: <20100119145108.GD2668@khazad-dum.debian.net>
References: <1263820516-6924-1-git-send-email-hagen@jauu.net> <20100119145108.GD2668@khazad-dum.debian.net>
Message-ID: <73f3c62cccfd75cb045a352320346c26@localhost>
User-Agent: RoundCube Webmail/0.1-rc1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 19 Jan 2010 12:51:08 -0200, <hmh@hmh.eng.br> wrote:

> Can you describe the problem in more detail?  That will save me precious
> time, as I am rather overworked right now...

If you build the sound as a module and thinkpad as a build-in component
the linker will complain about missing symbols. So the right fix may
be a patch that 1) enforces the sound component to be build static or
to enforces thinkpad apic to be build as a module. Another way 2) is
to separate the thinkpad sound component in a autonomous separate
module.

Any other ideas Henrique?

Hagen
