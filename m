Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZDNOLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZDNOLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZDNOLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:11:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51412 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbZDNOLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:11:40 -0400
Date: Tue, 14 Apr 2009 15:11:38 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] i2c: Fix warnings from I2C_BOARD_INFO()
Message-ID: <20090414141138.GK12678@sirena.org.uk>
References: <1239716822-29143-1-git-send-email-ben-linux@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239716822-29143-1-git-send-email-ben-linux@fluff.org>
X-Cookie: World War III?  No thanks!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 02:47:02PM +0100, Ben Dooks wrote:
> The first argument for this macro is a string, and
> thus having (arg) in the macro is causing gcc 4.2.4
> to produce warnings about strings of the form ("str").

Ben Hutchings submitted a patch for this recently which Jean merged.
