Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYEDKMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYEDKMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 06:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYEDKM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 06:12:26 -0400
Received: from ns.firmix.at ([62.141.48.66]:4612 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYEDKMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 06:12:25 -0400
Subject: Re: kconfig - a suggestion how to fix the select issue
From: Bernd Petrovitsch <bernd@firmix.at>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080504071041.GA15315@uranus.ravnborg.org>
References: <20080504071041.GA15315@uranus.ravnborg.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Sun, 04 May 2008 12:12:02 +0200
Message-Id: <1209895922.4114.21.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-9.fc7) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.334 required=5
X-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-04 at 09:10 +0200, Sam Ravnborg wrote:
> Today we have two ways to express/solve dependencies.
> 
> Top-down we have "depends on"
> and bottom up we have "select".
> 
> The "depends on" dependencies at the same
> time impact the visibility of a symbol.
> A symbol with "depends on" not satisfied are not
> visible and thus not shown in menuconfig.

Perhaps this is problem: The menu item shouldn't be selectable for sure
but it may well be visible (and I'm purposely ignoring details of "how
to grey out" for the different user interfaces).
If it's visible (but not selectable) the user interface can provide the
auto-generated requirements (derived from the "depends on" chains) as
part of the "help" or where ever it seems useful. And the user at least
knows where to look further.

> The "select" method is a way to forcefully
> set the selected symbol to the same value
> as the one where the select are stated.

Which makes sense from the usability point of view for typical library
functions (e.g. zlib, CRC, ...).
But that ("which CONFIG_ variables actually selected this CONFIG_
variable" and/or "which CONFIG_ variables will selected this CONFIG_
variable") could also be automatically generated and displayed.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

