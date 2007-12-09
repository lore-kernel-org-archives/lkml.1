Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbXLIWut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbXLIWut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXLIWum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:50:42 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:57894 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbXLIWul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:50:41 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 17:50:41 EST
Date: Sun, 9 Dec 2007 23:50:39 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net
Subject: Re: vcsa and big endian
Message-ID: <20071209225039.GB25047@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org,
	linuxconsole-dev@lists.sourceforge.net
References: <20071209224348.GA25292@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071209224348.GA25292@implementation>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Sun 09 Dec 2007 23:43:49 +0100, a écrit :
> On big endian machines, /dev/vcsa stores text/attribute bytes in big
> endian order, while it stores them in little endian order on little
> endian machines.  Is that expected?

It looks like ggi considers this as normal.  In any case, the vcsa
manual page should probably be made more clear ("but including
attributes" -> "but using unsigned shorts that include attributes" for
instance).

Samuel
