Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889Ab0ALJiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab0ALJiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768Ab0ALJiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:38:22 -0500
Received: from lazybastard.de ([212.112.238.170]:43638 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0ALJiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:38:21 -0500
Date: Tue, 12 Jan 2010 10:37:55 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Karel Zak <kzak@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.17 (stable)
Message-ID: <20100112093755.GB18822@logfs.org>
References: <20100108093302.GS1969@nb.net.home> <4B47A713.9060405@zytor.com> <20100111140255.GA1416@ucw.cz> <20100112071931.GA18822@logfs.org> <4B4C308C.6020804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B4C308C.6020804@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 January 2010 00:19:24 -0800, H. Peter Anvin wrote:
> 
> I believe for Smartmedia the FTL is done host side, but that there is a
> standard-specified FTL (called CIS, Card Information System.)

A CIS block/page is part of the FTL design.  Not sure whether it also
lends its name to it.  I'll just take your word for it.

Whether the FTL is done host side depends on the card reader and your
definition of host side.  Most old card readers implemented it in the
driver, but some newer ones prefer to export a usb mass storage
interface, thereby not requiring any driver CD.

Jörn

-- 
You cannot suppose that Moliere ever troubled himself to be original in the
matter of ideas. You cannot suppose that the stories he tells in his plays
have never been told before. They were culled, as you very well know.
-- Andre-Louis Moreau in Scarabouche
