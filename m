Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbXBFJv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbXBFJv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXBFJv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:51:26 -0500
Received: from office-abk.mandriva.com ([84.55.162.90]:4799 "EHLO
	office.mandriva.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbXBFJvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:51:25 -0500
X-Greylist: delayed 763 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Feb 2007 04:51:25 EST
To: Thomas =?iso-8859-15?Q?B=E4chler?= <thomas@archlinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.20] Regression in dmfe driver
X-URL: <http://www.mandrivalinux.com/
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	<eq87gu$5vo$1@sea.gmane.org>
From: Thierry Vignaud <tvignaud@mandriva.com>
Organization: Mandriva
Date: Tue, 06 Feb 2007 10:38:39 +0100
In-Reply-To: <eq87gu$5vo$1@sea.gmane.org> (Thomas =?iso-8859-15?Q?B=E4chle?=
 =?iso-8859-15?Q?r's?= message of "Mon\, 05 Feb 2007 22\:27\:58 +0100")
Message-ID: <m27iuvhbhc.fsf@vador.mandriva.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Bächler <thomas@archlinux.org> writes:

> Commit 7628b0a8c01a02966d2228bdf741ddedb128e8f8 (drivers/net/tulip/dmfe:
> support basic carrier detection) breaks networking on my Davicom DM9009.
> ethtool always reports there is no link. tcpdump shows incoming packets,
> but TX is disabled. Reverting the above patch fixes the problem.

disable link detection in your network config then (eg:
MII_NOT_SUPPORTED=yes in ifcfg-XXX depending on the distro).
