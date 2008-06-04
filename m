Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbYFDOmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbYFDOmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYFDOmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:42:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:52859 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbYFDOmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:42:31 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] watchdog: Strip stray space in log message
Date: Wed, 4 Jun 2008 16:42:15 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
References: <200806041538.53326.jdelvare@suse.de> <20080604150158.17a33e69@core>
In-Reply-To: <20080604150158.17a33e69@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806041642.15522.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Le mercredi 04 juin 2008, Alan Cox a écrit :
> On Wed, 4 Jun 2008 15:38:53 +0200
> Jean Delvare <jdelvare@suse.de> wrote:
> 
> > Strip a stray space in log messages of 3 watchdog drivers.
> > (And fold these long lines to make checkpatch.pl happy.)
> 
> Don't break up strings of quoted text - it makes grepping for them much
> harder.

As written above, checkpatch.pl told me to break them up.

CodingStyle says: "Long strings are as well broken into shorter
strings." And quite rightly so IMHO, if you have to rely on grepping
the whole kernel tree to find out where a log message comes from, it
means that this log message is bad and needs to be improved.

Thanks,
-- 
Jean Delvare
Suse L3
